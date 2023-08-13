import {
  Controller,
  Get,
  Param,
  Post,
  Request,
  UseInterceptors,
} from '@nestjs/common';
import { CompaniesService } from '../../domain/services/companies/companies.service';
import { ROLE } from '../../../../auth/domain/entities/roles';
import { Roles } from '../../../../auth/domain/guards/roles.decorator';
import { FastifyFileInterceptor } from '../../../../fastify.file.interceptor';
import { diskStorage } from 'fastify-multer';
import { join } from 'path';
import {
  editFileName,
  imageFileFilter,
} from '../../../../core/dto/file.upload.dto';
import { CompanyDto } from '../../domain/dtos/company.dto';
import { validateOrReject } from 'class-validator';
import { WrapperDto } from '../../../../core/dto/wrapper.dto';

@Controller('companies')
export class CompaniesController {
  constructor(readonly companiesService: CompaniesService) {}

  @Roles(ROLE.ADMIN, ROLE.USER)
  @Post('add')
  @UseInterceptors(
    FastifyFileInterceptor('banner', {
      storage: diskStorage({
        destination: join(process.cwd(), 'assets', 'public'),
        filename: editFileName,
      }),
      limits: {
        fieldSize: 10485760,
      },
      fileFilter: imageFileFilter,
    }),
  )
  async add(@Request() request) {
    try {
      const companyDto = new CompanyDto(request.body);
      await validateOrReject(companyDto);
      const result = await this.companiesService.add(request, companyDto);
      return WrapperDto.successfullCreated(result);
    } catch (error) {
      return WrapperDto.figureOutTheError(error);
    }
  }

  @Roles(ROLE.ADMIN, ROLE.USER)
  @Post('edit/:id')
  @UseInterceptors(
    FastifyFileInterceptor('banner', {
      storage: diskStorage({
        destination: join(process.cwd(), 'assets', 'public'),
        filename: editFileName,
      }),
      limits: {
        fieldSize: 10485760,
      },
      fileFilter: imageFileFilter,
    }),
  )
  async edit(@Request() request, @Param('id') id: number) {
    try {
      const companyDto = new CompanyDto(request.body);
      await validateOrReject(companyDto);
      const result = await this.companiesService.edit(request, id, companyDto);
      return WrapperDto.successfullCreated(result);
    } catch (error) {
      return WrapperDto.figureOutTheError(error);
    }
  }

  @Roles(ROLE.ADMIN, ROLE.USER)
  @Get(':id')
  async find(@Request() request, @Param('id') id: number) {
    try {
      const result = await this.companiesService.findOne(id);
      return WrapperDto.successfullCreated(result);
    } catch (error) {
      return WrapperDto.figureOutTheError(error);
    }
  }

  @Roles(ROLE.ADMIN, ROLE.USER)
  @Get('findAll')
  async findAll(@Request() request) {
    try {
      const result = await this.companiesService.findAll();
      return WrapperDto.paginate(result, request.query);
    } catch (error) {
      return WrapperDto.figureOutTheError(error);
    }
  }

  @Roles(ROLE.ADMIN, ROLE.USER)
  @Get('findWithIds')
  async findWithIds(@Request() request) {
    try {
      const result = await this.companiesService.findWithIds(request);
      return WrapperDto.paginate(result['datas'], request.query);
    } catch (error) {
      return WrapperDto.figureOutTheError(error);
    }
  }

  @Roles(ROLE.USER)
  @Get('get')
  async get(@Request() request) {
    try {
      const result = await this.companiesService.get(request);
      return WrapperDto.paginate(result, request.query);
    } catch (error) {
      return WrapperDto.figureOutTheError(error);
    }
  }
}