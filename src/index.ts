import { registerPlugin } from '@capacitor/core';

import type { StableDiffusionPlugin } from './definitions';

const StableDiffusion = registerPlugin<StableDiffusionPlugin>(
  'StableDiffusion',
  {
    web: () => import('./web').then(m => new m.StableDiffusionWeb()),
  },
);

export * from './definitions';
export { StableDiffusion };
