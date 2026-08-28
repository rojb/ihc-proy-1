import {
  BadRequestException,
  createParamDecorator,
  ExecutionContext,
} from '@nestjs/common';
import type { Request } from 'express';

export const DEVICE_ID_HEADER = 'x-device-id';

function readDeviceId(context: ExecutionContext): string | undefined {
  const request = context.switchToHttp().getRequest<Request>();
  const raw = request.headers[DEVICE_ID_HEADER];
  const value = Array.isArray(raw) ? raw[0] : raw;
  return value?.trim() || undefined;
}

/**
 * FR-07 · Identificador local del dispositivo. No hay cuentas: este header es
 * todo lo que tenemos para no contar dos veces a la misma persona y para saber
 * quién puede editar un evento (OQ-4). Obligatorio en toda escritura.
 */
export const DeviceId = createParamDecorator(
  (_data: unknown, context: ExecutionContext): string => {
    const deviceId = readDeviceId(context);
    if (!deviceId) {
      throw new BadRequestException(
        `Falta el header ${DEVICE_ID_HEADER}. La app lo genera al primer uso.`,
      );
    }
    return deviceId;
  },
);

/**
 * En las lecturas el identificador es opcional: sirve para saber si este
 * dispositivo ya marcó interés, pero la lista se puede ver sin él.
 */
export const OptionalDeviceId = createParamDecorator(
  (_data: unknown, context: ExecutionContext): string | undefined =>
    readDeviceId(context),
);
