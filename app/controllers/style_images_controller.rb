class StyleImagesController < ApplicationController
    
    #ログイン時にstyle_imageのレコードが作成した。
    def edit
        @style_image =  StyleImage.find(params[:id])
    end

    def update
        @style_image = StyleImage.find(params[:id])
        @style_image.update(style_images_params)
        redirect_to edit_style_image_path(@style_image.id)
    end

    def destroy
        @style_image = StyleImage.find(params[:id])
        @image_array = @style_image.hair_images
        @image_array.delete_at(params[:number].to_i)
        @style_image.save
        redirect_to edit_style_image_path(@style_image.id)
    end

    private
    def style_images_params
        params.require(:style_image).permit({hair_images:[]})
    end

end
