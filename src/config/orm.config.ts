import { User } from '../modules/users/domain/entities/user.entity';
import { Token } from '../auth/domain/entities/token.entity';
import * as dotenv from 'dotenv';
import { Chat } from '../modules/chats/domain/entities/chat.entity';
import { Company } from '../modules/companies/domain/entities/company.entity';
import { Favorite } from '../modules/users/domain/entities/favorite.entity';
import { Tag } from '../modules/companies/domain/entities/tag.entity';
import { ChatTrainer } from '../modules/chats/domain/entities/chat.trainer.entity';
import { TagIdentifier } from '../modules/companies/domain/entities/tag.identifier.entity';
import { CompanyIdentifier } from '../modules/companies/domain/entities/company.identifier.entity';
import { Suggestion } from '../modules/chats/domain/entities/suggestion.entity';
import { ChatDocument } from '../modules/chats/domain/entities/chat.document.entity';
import { Session } from '../modules/users/domain/entities/session.entity';
import { Notification } from '../modules/notifications/domain/entities/notification.entity';

dotenv.config({ path: '.env' });

export const config = {
  // name: 'linkoai',
  type: 'mysql',
  // driver: 'mysql',
  host: `${process.env.DATABASE_HOST}`,
  port: Number(process.env.DATABASE_PORT),
  username: `${process.env.DATABASE_USERNAME}`,
  password: `${process.env.DATABASE_PASSWORD}`,
  database: `${process.env.DATABASE_NAME}`,
  seeds: ['src/database/seeds/**/*{.ts,.js}'],
  factories: ['src/database/seeds/factories/**/*{.ts,.js}'],
  entities: [
    User,
    Token,
    Notification,
    Tag,
    Company,
    Favorite,
    Chat,
    ChatTrainer,
    ChatDocument,
    TagIdentifier,
    CompanyIdentifier,
    Suggestion,
    Session,
  ],
  migrations: ['./src/database/migrations/*{.ts,.js}'],
  synchronize: true,
  cli: {
    migrationsDir: './src/database/migrations',
  },
  autoLoadEntities: true,
};