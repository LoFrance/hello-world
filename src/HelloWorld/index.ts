import {
  HttpResponseInit,
  InvocationContext,
  app,
  output,
  trigger
} from '@azure/functions';
import createHandler from './handler';
import { ConfigData, getConfigOrThrow } from '../utils/config';

const config = getConfigOrThrow();

const httpStart = (config: ConfigData) => {
  app.http('GetEnv', {
    methods: ['GET'],
    route: 'v1/env',
    authLevel: 'anonymous',
    handler: async (request, context): Promise<HttpResponseInit> => {
      try {
        context.log(`Http function processed request for url "${request.url}"`);

        return { body: `Env: ${JSON.stringify(config)}!` };
      } catch (error) {
        return {
          status: 400,
          body: `Error: ${context.error(error)}`
        };
      }
    }
  });
  app.http('HelloWorldByPost', {
    methods: ['POST'],
    route: 'v1/hello/{name}',
    authLevel: 'anonymous',

    handler: async (request, context: InvocationContext) =>
      createHandler(request, context)
  });
  app.generic('HelloWorld', {
    trigger: trigger.generic({
      type: 'httpTrigger',
      methods: ['GET', 'POST'],
      route: 'v1/hello',
      authLevel: 'anonymous'
    }),
    return: output.generic({
      type: 'http'
    }),
    handler: async (request, context): Promise<HttpResponseInit> => {
      try {
        context.log(`Http function processed request for url "${request.url}"`);

        const name =
          request.query.get('name') || (await request.text()) || 'world';

        return { body: `Hello, ${name}!` };
      } catch (error) {
        return {
          status: 400,
          body: `Error: ${context.error(error)}`
        };
      }
    }
  });
};

export default httpStart(config);
