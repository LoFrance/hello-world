import { getHandler } from '../handler';

describe('Handler test', () => {
  it('should add two number', () => {
    const handler = getHandler();
    const res = handler.add(1, 2);
    expect(res).toBe(3);
  });
});
