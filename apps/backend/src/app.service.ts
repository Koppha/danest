import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  health() {
    return { status: 'ok', service: 'de-nest-backend', timestamp: new Date().toISOString() };
  }
}
