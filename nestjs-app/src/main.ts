import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { FastifyAdapter, NestFastifyApplication } from '@nestjs/platform-fastify';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter()
  );
  
  // Bind to 0.0.0.0 for Docker container routing
  await app.listen(8000, '0.0.0.0');
  console.log('NestJS (Fastify) running on port 8000');
}
bootstrap();
