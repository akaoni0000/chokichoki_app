class StyleImagesController < ApplicationController
    
    #ログイン時にstyle_imageのレコードが作成した。
    def edit
        @style_image =  StyleImage.find_by(hairdresser_id: @current_hairdresser.id)
        gon.image_number = @style_image.hair_images.size 
    end

    def update
        @style_image_add = StyleImage.new(style_images_params)
        @style_image_add.save
        binding.pry
        @style_image = StyleImage.find_by(hairdresser_id: @current_hairdresser.id)
        @style_image.hair_images.push(@style_image_add.hair_images)
        @style_image.hair_images.flatten!
        @style_image.save
        @style_image_add.destroy
        #@style_image.update(style_images_params)
        redirect_to hairdresser_path(@current_hairdresser.id)
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
