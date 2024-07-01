import { getHandler } from './handler';

export const hello = () => getHandler().add(1, 2);
