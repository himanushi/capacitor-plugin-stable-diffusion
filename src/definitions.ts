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
  savePath: string;
  prompt: string;
  seed: number;
}

export type DownloadProgressListener = (data: { progress: number }) => void;

export type DownloadDidCompleteResult = {
  state: 'completed' | 'fail';
  error?: string;
};

export type DownloadDidCompleteListener = (
  data: DownloadDidCompleteResult,
) => void;

export type UnzipDidCompleteResult = {
  state: 'completed';
};

export type UnzipDidCompleteListener = (data: UnzipDidCompleteResult) => void;

export type GenerateProgressListener = (data: { progress: number }) => void;

export type GenerateDidCompleteResult = {
  state: 'completed' | 'fail';
  filePath?: string;
  error?: string;
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
