import type { PluginListenerHandle } from '@capacitor/core';

export interface DownloadOptions {
  url: string;
  modelsDirName: string;
}

export interface UnzipOptions {
  url: string;
  modelsDirName: string;
}

export interface GenerateTextToImageOptions {
  modelPath: string;
  prompt: string;
}

export type DownloadProgressListener = (data: number) => void;

export type DownloadDidCompleteResult = {
  state: 'completed' | 'fail';
};

export type DownloadDidCompleteListener = (
  data: DownloadDidCompleteResult,
) => void;

export type UnzipProgressListener = (data: number) => void;

export type UnzipDidCompleteResult = {
  state: 'completed' | 'fail';
};

export type UnzipDidCompleteListener = (data: UnzipDidCompleteResult) => void;

export type GenerateProgressListener = (data: number) => void;

export type GenerateDidCompleteResult = {
  state: 'completed' | 'fail';
  image?: string;
};

export type GenerateDidCompleteListener = (
  data: GenerateDidCompleteResult,
) => void;

export interface StableDiffusionPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  download(options: DownloadOptions): Promise<void>;
  unzip(options: UnzipOptions): Promise<void>;
  generateTextToImage(options: GenerateTextToImageOptions): Promise<void>;
  addListener(
    eventName: 'downloadProgress',
    listenerFunc: DownloadProgressListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: 'downloadDidComplete',
    listenerFunc: DownloadDidCompleteListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: 'unzipProgress',
    listenerFunc: UnzipProgressListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: 'unzipDidComplete',
    listenerFunc: UnzipDidCompleteListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: 'generateProgress',
    listenerFunc: GenerateProgressListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
  addListener(
    eventName: 'generateDidComplete',
    listenerFunc: GenerateDidCompleteListener,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
}
