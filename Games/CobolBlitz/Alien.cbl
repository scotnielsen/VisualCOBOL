      ********************************************************************************************************
      *
      *  This sample is provided under the terms of the Microsoft Public License agreement(Ms-Pl).
      *  For more information, review the ms-pl.txt file in the demonstration folder.
      *
      *  This sample code is supplied for demonstration purposes only on an "as is" basis and "is for use at
      *  your own risk".
      *
      ********************************************************************************************************

       class-id CobolBlitz.Alien inherits type Sprite.

       working-storage section.
       78 Width    binary-long value 48 public.
       78 Height   binary-long value 48 public.

       method-id NEW.
       local-storage section.
       procedure division using by value gameState as type GameState l-x as float-short l-y as float-short l-sz as type AlienSizeEnum.
           evaluate l-sz
           when type AlienSizeEnum::Small
               invoke super::Construct(gameState l-x l-y "graphics\invader32x32_1.bmp" "graphics\invader32x32_2.bmp" type GameObjectEnum::Alien)
           when type AlienSizeEnum::Medium
               invoke super::Construct(gameState l-x l-y "graphics\invader36x32_1.bmp" "graphics\invader36x32_2.bmp" type GameObjectEnum::Alien)
           when other
               invoke super::Construct(gameState l-x l-y "graphics\invader40x32_1.bmp" "graphics\invader40x32_2.bmp" type GameObjectEnum::Alien)
           end-evaluate
       end method.

       end class.
