import type { StableDiffusionPlugin } from "./definitions";
import { registerPlugin } from "@capacitor/core";

const StableDiffusion = registerPlugin<StableDiffusionPlugin>(
  "StableDiffusion",
  {
    web: () => import("./web").then((m) => new m.StableDiffusionWeb()),
  },
);

export * from "./definitions";
export { StableDiffusion };
