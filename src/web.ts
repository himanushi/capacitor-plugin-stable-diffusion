import { WebPlugin } from '@capacitor/core';

import type {
  DownloadOptions,
  GenerateTextToImageOptions,
  StableDiffusionPlugin,
} from './definitions';

export class StableDiffusionWeb
  extends WebPlugin
  implements StableDiffusionPlugin
{
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('echo', options);
    return options;
  }

  async download(options: DownloadOptions): Promise<void> {
    console.log('download', options);
  }

  async unzip(options: DownloadOptions): Promise<void> {
    console.log('unzip', options);
  }

  async generateTextToImage(
    options: GenerateTextToImageOptions,
  ): Promise<void> {
    console.log('generateTextToImage', options);
  }
}
