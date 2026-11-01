import type { Design } from './designs';

export type DesignPicture = { design: Design; image: string; label: string; viewIndex: number };

export function designImageSource(image: string) {
  return image.startsWith('/') ? image : `/concepts/${image}`;
}

export function designPictures(design: Design): DesignPicture[] {
  const views = design.views?.length ? design.views : [{ image: design.image, label: design.title }];
  return views.map((view, viewIndex) => ({ design, ...view, viewIndex }));
}

export function galleryPictures(designs: readonly Design[]) {
  return designs.flatMap(designPictures);
}

export function pictureIndex(pictures: readonly DesignPicture[], selection: Design) {
  const exact = pictures.findIndex(picture => picture.design.id === selection.id && picture.image === selection.image);
  return exact >= 0 ? exact : pictures.findIndex(picture => picture.design.id === selection.id);
}

export function movePicture(index: number, direction: -1 | 1, count: number) {
  return count > 0 ? (index + direction + count) % count : 0;
}

// A viewer selection preserves the voting ID. It never mutates the catalog.
export function pictureSelection(picture: DesignPicture): Design {
  return picture.image === picture.design.image ? picture.design : { ...picture.design, image: picture.image };
}
