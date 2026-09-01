import { Global, Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { AuthController } from './auth.controller.js';
import { AuthService } from './auth.service.js';

// Global: JwtAuthGuard (used via @UseGuards across nearly every feature
// module) depends on JwtService, so JwtModule needs to be visible wherever
// that guard is instantiated — exporting it from a @Global module avoids
// importing AuthModule into every feature module just for that.
@Global()
@Module({
  imports: [JwtModule.register({})],
  controllers: [AuthController],
  providers: [AuthService],
  exports: [AuthService, JwtModule],
})
export class AuthModule {}
