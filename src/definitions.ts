import type { PluginListenerHandle } from "@capacitor/core";

export interface DownloadOptions {
  modelsDirName: string;
  url: string;
}

export interface UnzipOptions {
  modelsDirName: string;
  url: string;
}

export interface GenerateTextToImageOptions {
  modelPath: string;
  prompt: string;
  savePath: string;
  seed: number;
}

export type DownloadProgressListener = (data: { progress: number }) => void;

export type DownloadDidCompleteResult = {
  error?: string;
  state: "completed" | "fail";
};

export type DownloadDidCompleteListener = (
  data: DownloadDidCompleteResult,
) => void;

export type UnzipDidCompleteResult = {
  state: "completed";
};

export type UnzipDidCompleteListener = (data: UnzipDidCompleteResult) => void;

export type GenerateProgressListener = (data: { progress: number }) => void;

export type GenerateDidCompleteResult = {
  error?: string;
  filePath?: string;
  state: "completed" | "fail";
};

export type GenerateDidCompleteListener = (
  data: GenerateDidCompleteResult,
) => void;

export interface StableDiffusionPlugin {
  addListener(
    eventName: "downloadProgress",
    listenerFunc: DownloadProgressListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: "downloadDidComplete",
    listenerFunc: DownloadDidCompleteListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: "unzipDidComplete",
    listenerFunc: UnzipDidCompleteListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: "generateProgress",
    listenerFunc: GenerateProgressListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: "generateDidComplete",
    listenerFunc: GenerateDidCompleteListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  download(options: DownloadOptions): Promise<void>;
  echo(options: { value: string }): Promise<{ value: string }>;
  generateTextToImage(options: GenerateTextToImageOptions): Promise<void>;
  unzip(options: UnzipOptions): Promise<void>;
}
