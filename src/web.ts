import type {
  DownloadOptions,
  GenerateTextToImageOptions,
  GetImagesOptions,
  GetImagesResult,
  StableDiffusionPlugin,
} from "./definitions";
import { WebPlugin } from "@capacitor/core";

export class StableDiffusionWeb
  extends WebPlugin
  implements StableDiffusionPlugin {
  async echo (options: { value: string }): Promise<{ value: string }> {
    console.log("echo", options);
    return options;
  }

  async download (options: DownloadOptions): Promise<void> {
    console.log("download", options);
  }

  async unzip (options: DownloadOptions): Promise<void> {
    console.log("unzip", options);
  }

  async getImages (options: GetImagesOptions): Promise<GetImagesResult> {
    console.log("getImages", options);
    return [] as any;
  }

  async generateTextToImage (
    options: GenerateTextToImageOptions,
  ): Promise<void> {
    console.log("generateTextToImage", options);
  }
}
