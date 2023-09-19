import { Injectable } from '@nestjs/common';
import {
  DataSource,
  In,
  IsNull,
  LessThan,
  MoreThan,
  MoreThanOrEqual,
} from 'typeorm';
import { Socket } from 'socket.io';
import { WsException } from '@nestjs/websockets';
import { Chat } from '../entities/chat.entity';
import { Token } from '../../../../auth/domain/entities/token.entity';
import { CreateChatDto } from '../dto/create-chat.dto';
import { User } from '../../../users/domain/entities/user.entity';
import { NlpManager } from 'node-nlp';
import * as fs from 'fs';
import { Tag } from '../../../companies/domain/entities/tag.entity';
import { Company } from '../../../companies/domain/entities/company.entity';
import { join } from 'path';
import { ChatDocument } from '../entities/chat.document.entity';

@Injectable()
export class ChatsService {
  add(request: any) {
    throw new Error('Method not implemented.');
  }
  edit(request: any) {
    throw new Error('Method not implemented.');
  }
  constructor(readonly dataSource: DataSource) {}

  async delete(request: any, id: number): Promise<any> {
    const chat = await this.dataSource
      .getRepository(Chat)
      .findOne({ where: { id: id }, relations: ['sender', 'receiver'] });

    let can = false;
    if (chat.receiver != null && chat.receiver.id == request.user.id) {
      can = true;
    }

    if (chat.sender != null && chat.sender.id == request.user.id) {
      can = true;
    }
    if (!can) {
      throw Error('Sorry You can\t delete this message');
    }

    return await this.dataSource.getRepository(Chat).delete({
      id: id,
    });
  }

  async clearAll(request: any): Promise<any> {
    const user = await this.dataSource
      .getRepository(User)
      .findOneBy({ id: request.user.id });

    const chats = await this.dataSource.getRepository(Chat).find({
      where: [{ receiver: user }, { sender: user }],
      relations: ['sender', 'receiver'],
    });
    if (
      request.query.soft == undefined ||
      request.query.soft == null ||
      request.query.soft == 'false'
    ) {
      return await this.dataSource.getRepository(Chat).delete({
        id: In(chats.map((c) => c.id)),
      });
    } else {
      return await this.dataSource
        .createQueryBuilder()
        .update(Chat)
        .set({ isActive: false })
        .where('senderId = :id ', { id: user.id })
        .orWhere('receiverId = :id ', { id: user.id })
        .execute();
    }
  }

  async clear(request: any): Promise<any> {
    const user = await this.dataSource
      .getRepository(User)
      .findOneBy({ id: request.user.id });

    const id = request.query.id;

    const chats = await this.dataSource.getRepository(Chat).find({
      where: [
        { receiver: user, id: MoreThanOrEqual(id) },
        { sender: user, id: MoreThanOrEqual(id) },
      ],
      take: 2,
      relations: ['sender', 'receiver'],
    });
    if (chats.length == 0) return true;
    const toDelete = [chats[0].id];
    if (chats.length > 1 && chats[1].sender == null) {
      toDelete.push(chats[1].id);
    }
    if (
      request.query.soft == undefined ||
      request.query.soft == null ||
      request.query.soft == 'false'
    ) {
      return await this.dataSource.getRepository(Chat).delete({
        id: In(toDelete),
      });
    } else {
      return await this.dataSource
        .createQueryBuilder()
        .update(Chat)
        .set({ isActive: false })
        .whereInIds(toDelete)
        .execute();
    }
  }

  async getUserFromSocket(socket: Socket) {
    const auth_token =
      socket.handshake.auth.authorization ??
      socket.handshake.headers.authorization;

    if (auth_token == null || auth_token.length == 0) {
      throw new WsException('Invalid credentials.');
    }

    const jwt = auth_token.replace('Bearer ', '');
    const token = await this.dataSource.getRepository(Token).findOne({
      where: { token: jwt },
      relations: {
        user: true,
      },
    });

    // const token = await this.dataSource.getRepository(Token).findOne({
    //   where: { id: MoreThan(0) },
    //   relations: {
    //     user: true,
    //   },
    // });

    if (token == null) {
      throw new WsException('Invalid credentials.');
    } else return token.user;
  }

  async create(request: any, createChatDto: CreateChatDto): Promise<Chat> {
    const user = await this.dataSource
      .getRepository(User)
      .findOne({ where: { id: request.user.id } });
    let chat = new Chat();
    chat.data = createChatDto.data;
    chat.type = createChatDto.type;
    chat.sender = user;
    chat = await this.dataSource.getRepository(Chat).save(chat);
    //document chat;
    const chatDoc = new ChatDocument();
    chatDoc.sender = user;
    chatDoc.isActive = true;
    chatDoc.text = createChatDto.data;
    await this.dataSource.getRepository(ChatDocument).save(chatDoc);
    //
    return chat;
  }

  async findAll(request: any): Promise<any> {
    const limit = request.query.limit ?? 25;
    const page = request.query.page ?? 1;
    const id = request.query.id ?? -1;
    const isActive = request.query.isActive ?? -1;

    const user = await this.dataSource
      .getRepository(User)
      .findOne({ where: { id: request.user.id, isActive: true } });

    const sqlQuery = [
      { sender: user, isActive: (isActive ?? 'true') == 'true' },
      { receiver: user, isActive: (isActive ?? 'true') == 'true' },
    ];

    const [chats, count] = await this.dataSource
      .getRepository(Chat)
      .findAndCount({
        where:
          id > 0
            ? [
                {
                  sender: user,
                  id: LessThan(id),
                  isActive: (isActive ?? 'true') == 'true',
                },
                {
                  receiver: user,
                  id: LessThan(id),
                  isActive: (isActive ?? 'true') == 'true',
                },
              ]
            : sqlQuery,
        take: limit,
        relations: ['sender', 'receiver'],
        order: {
          id: 'DESC',
        },
        skip: id > 0 ? 0 : limit * (page - 1),
      });

    return {
      data: chats,
      count: count,
    };
  }

  // async findAllUnDocumented(request: any): Promise<any> {
  //   const limit = request.query.limit ?? 25;
  //   const page = request.query.page ?? 1;
  //   const id = request.query.id ?? -1;

  //   const user = await this.dataSource
  //     .getRepository(User)
  //     .findOne({ where: { id: request.user.id, isActive: true } });

  //   const sqlQuery = [{ receiver: IsNull(), isDocumented: false }];

  //   const [chats, count] = await this.dataSource
  //     .getRepository(Chat)
  //     .findAndCount({
  //       where:
  //         id > 0
  //           ? [
  //               {
  //                 receiver: IsNull(),
  //                 id: LessThan(id),
  //                 isDocumented: false,
  //               },
  //             ]
  //           : sqlQuery,
  //       take: limit,
  //       relations: ['sender', 'receiver'],
  //       order: {
  //         id: 'DESC',
  //       },
  //       skip: id > 0 ? 0 : limit * (page - 1),
  //     });

  //   return {
  //     data: chats,
  //     count: count,
  //   };
  // }

  async respondToClient(receivedChat: Chat): Promise<Chat> {
    const chat = new Chat();
    chat.receiver = receivedChat.sender;

    const previousChat = await this.getPreviousMessage(receivedChat);
    const aiResp = await this.getTrainedAiResponse(
      receivedChat.data,
      previousChat,
    );
    [chat.type, chat.data, chat.context] = await this.processAIResponse(
      aiResp,
      previousChat?.context == null ? null : JSON.parse(previousChat.context),
    );
    if (chat.type == 'text') {
      // console.log(
      //   '\ntext: ',
      //   chat.data == null
      //     ? 'Fallback'
      //     : chat.data.replaceAll('{{name}}', receivedChat.sender.fullName),
      // );
      console.log('chat.data: ', chat.data);
      if (chat.data != null) {
        if (chat.data == 'empty') {
          const emptyResp = await this.getTrainedAiResponse(
            'empty',
            previousChat,
          );
          chat.data =
            emptyResp['answer'] ?? 'No business Found with this specification';
        }
        chat.data = chat.data.replaceAll(
          '{{name}}',
          receivedChat.sender.fullName,
        );
      } else {
        const fallbackAIResp = await this.getTrainedAiResponse(
          'fallback',
          previousChat,
        );
        console.log('fallback resonse: ', fallbackAIResp['answer']);
        chat.data =
          fallbackAIResp['answer'] ??
          'Sorry i am not trained yet to respond to this kind of queries';
      }
    } else {
      console.log('\ndata: ', chat.data);
    }
    return await this.dataSource.getRepository(Chat).save(chat);
  }

  async getTrainedAiResponse(
    utterance: string,
    previosChat: Chat | null,
  ): Promise<any> {
    const path = join(
      __dirname.substring(0, __dirname.lastIndexOf('dist')),
      '/linko-ai.nlp',
    );
    // console.log('loading from ', path);
    console.log('sent Message: ', utterance.replaceAll('-', ' '));
    const data = fs.readFileSync(path, 'utf8');
    const manager = new NlpManager({
      languages: ['en', 'ar'],
      forceNER: true,
      nlu: { useNoneFeature: false, log: true },
    });
    manager.import(data);
    const response = await manager.process(utterance.replaceAll('-', ' '));
    console.log('intent', response['intent']);
    console.log('response', response['answer']);
    return response;
  }

  async parseTagFromEntities(entities: any[]): Promise<Tag[]> {
    if (entities.length == 0) return [];
    const entitiesName = entities.map((e) => e['entity']);
    return await this.dataSource.getRepository(Tag).find({
      where: [{ name: In(entitiesName) }, { arabicName: In(entitiesName) }],
    });
  }

  getTagIds(tags: Tag[]) {
    if (tags.length == 0) return '()';
    return '( ' + tags.map((t) => t.id).join(', ') + ' )';
  }

  async getPreviousMessage(chat: Chat): Promise<Chat | null> {
    return await this.dataSource.getRepository(Chat).findOne({
      where: { sender: chat.sender, id: LessThan(chat.id) },
      order: { id: 'DESC' },
    });
  }

  async getBusinessesFromTags(tags: Tag[], context: any): Promise<any | null> {
    //
    await this.dataSource
      .createQueryBuilder()
      .update(Tag)
      .set({
        searchCount: () => 'searchCount + 1',
      })
      .where('id in (:ids)', { ids: tags.map((c) => c.id) })
      .execute();
    //
    const sql_query =
      'SELECT companyID as id FROM company_tag_id where tagID in ' +
      this.getTagIds(tags) +
      ' GROUP BY companyID HAVING COUNT(tagID) = ' +
      tags.length +
      ';';
    //
    const result = await this.dataSource
      .createQueryRunner()
      .manager.query(sql_query);
    if (result == null || result == undefined || result.length == 0)
      return { datas: [], count: 0 };
    const companyIDs: number[] = result.map((r) => r['id']);

    //
    // const limit =
    //   context != null && context['limit'] != null ? context['limit'] : 5;
    // //
    // const page =
    //   context != null && context['page'] != null ? context['page'] : 1;
    // //
    // const id = context != null && context['id'] != null ? context['id'] : -1;
    // //
    // if (id > 0) {
    //   companyIDs = companyIDs.filter((companyID) => companyID > id);
    // }
    const [comps, count] = await this.dataSource
      .getRepository(Company)
      .findAndCount({
        where: { id: In(companyIDs), isActive: true },
        // relations: ['favoritesof'],
        // take: limit,
        select: ['id'],
        // skip: id > 0 ? 0 : limit * (page - 1),
      });
    if (comps == null || count == null || comps.length == 0 || count == 0)
      return null;
    else {
      await this.dataSource
        .createQueryBuilder()
        .update(Company)
        .set({
          found: () => 'found + 1',
        })
        .where('id in (:ids)', { ids: comps.map((c) => c.id) })
        .execute();

      return {
        datas: comps.length > 0 ? comps.map((c) => c.id) : comps,
        count: count,
      };
    }
  }

  async processAIResponse(
    aiResponse: any,
    proviousAiResponse: any | null,
  ): Promise<[type: string, data: string, context: string]> {
    let type = 'text';
    let data = aiResponse['answer'];
    let context = aiResponse;
    const currentTags = await this.parseTagFromEntities(aiResponse['entities']);
    if (
      false &&
      proviousAiResponse != null &&
      proviousAiResponse['slotFill'] != null &&
      proviousAiResponse['slotFill']['currentSlot'] != null
    ) {
      type = 'text';
      data = aiResponse['answer'];
    } else {
      if (
        false &&
        aiResponse['slotFill'] != null &&
        aiResponse['slotFill']['currentSlot'] != null
      ) {
        type = 'text';
        data = aiResponse['answer'];
        context = aiResponse;
      } else if (currentTags.findIndex((val) => val.canDetermine) != -1) {
        type = 'companies';
        context = this.addPageNumberToContext(context, proviousAiResponse);
        const business = await this.getBusinessesFromTags(currentTags, context);
        if (business == null) {
          type = 'text';
          data = 'empty';
        } else data = JSON.stringify(business);
      } else if (currentTags.length > 0) {
        const previousTags = await this.parseTagFromEntities(
          proviousAiResponse == null ? [] : proviousAiResponse['entities'],
        );
        if (previousTags.findIndex((val) => val.canDetermine) != -1) {
          type = 'companies';
          context = this.addPageNumberToContext(context, null);

          context['entities'] = [
            ...context['entities'],
            ...proviousAiResponse['entities'],
          ];
          const business = await this.getBusinessesFromTags(
            [...currentTags, ...previousTags],
            context,
          );
          if (business == null) {
            type = 'text';
            data = 'empty';
          } else data = JSON.stringify(business);
        } else {
          type = 'text';
          data = aiResponse['answer'] ?? 'Fallback';
        }
      }
    }
    // check if there is a slot request on the previous message;
    //   if there is a slot request then replace the current utterance on the requested slot
    //     then request the ai response again with the replacement
    // if there is no slot request on the previous message
    //   check if the current aiResponse is requesting slot
    //       if it is requesting slot then respond the aiResponse
    //   else check if there is a determinant entity ( a tag that is determinant );
    //       if there is respond the companies
    //   else check if there is an undeterminant entity
    //       if there is undeterminant entity use the entities from the previous message and find dtereminant
    //           if determinant is found respond companies;
    //       else respond the ai response;
    //   respond the ai response
    delete context['answers'];
    delete context['nluAnswers'];

    if (type != 'text') {
      if (
        data == undefined ||
        data == null ||
        (data as string).trim().endsWith(':0}')
      ) {
        type = 'text';
        data = 'empty';
      }
    }
    return [type, data, JSON.stringify(context)];
  }

  addPageNumberToContext(context: any, previousContext: any) {
    if (context == null) return null;
    if (previousContext != null && previousContext['page'] != null) {
      context['page'] = previousContext['page'] + 1;
    } else if (context['page'] != null) context['page'] += context['page'];
    else context['page'] = 1;
    if (context['limit'] == null) context['limit'] = 5;
    return context;
  }

  async checkIfEntitiesAreEqual(
    entities1: any[],
    entities2: any[],
  ): Promise<boolean> {
    if (entities1 == null && entities2 == null) return true;
    if (entities1.length == 0 && entities2.length == 0) return true;
    const entities1Names = entities1.map((e) => e['entity']);
    const entities2Names = entities2.map((e) => e['entity']);
    let result = entities1Names.every(function (val) {
      return entities2Names.indexOf(val) >= 0;
    });
    if (result) {
      result = entities2Names.every(function (val) {
        return entities1Names.indexOf(val) >= 0;
      });
    }
    return result;
  }
}