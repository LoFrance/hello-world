import { HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';

const createHandler = async (
  request: HttpRequest,
  context: InvocationContext
): Promise<HttpResponseInit> => {
  context.log(`Http function processed request for url "${request.url}"`);

  const name = request.params['name'];
  const { age, surname } = JSON.parse(await request.text());
  if (!age || !surname) {
    return {
      status: 400,
      body: `Bad Request, missing ${!age ? 'age' : ''} ${!surname ? 'surname' : ''}`
    };
  }

  return { body: `Hello ${name} ${surname}, ${age} years old.`, status: 200 };
};

export default createHandler;
