import { ZodError, z } from 'zod';
import dotenv from 'dotenv';

const ConfigData = z.object({
  SECRET_FAKE: z
    .string({
      required_error: 'Api Key is required',
      invalid_type_error: 'Api Key must be present in the environment variables'
    })
    .min(1)
    .max(255, { message: 'Api Key is too long' }),
  OTHERKEY: z.string().optional()
});
export type ConfigData = z.infer<typeof ConfigData>;

dotenv.config();
const envConfig = {
  ...process.env,
  SECRET_FAKE: process.env.SECRET_FAKE,
  OTHERKEY: process.env.OTHERKEY
};

export const getConfigOrThrow = () => {
  try {
    const errorOrConfig = ConfigData.parse(envConfig);

    return errorOrConfig;
  } catch (e) {
    console.error('Validation error:');
    if (e instanceof ZodError) {
      e.errors.map(error => console.log(error.message));
    }
    throw new Error(`Invalid configuration!`);
  }
};
