export interface SendSmsResult {
  providerMessageId?: string;
}

export interface SmsProvider {
  send(to: string, body: string, from: string): Promise<SendSmsResult>;
}

export const SMS_PROVIDER = Symbol('SMS_PROVIDER');
