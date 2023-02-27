export interface StableDiffusionPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
