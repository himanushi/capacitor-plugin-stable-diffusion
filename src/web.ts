import { WebPlugin } from '@capacitor/core';

import type { StableDiffusionPlugin } from './definitions';

export class StableDiffusionWeb
  extends WebPlugin
  implements StableDiffusionPlugin
{
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
