class StyleImagesController < ApplicationController
    
    #ログイン時にstyle_imageのhairdresser_idカラムがログインしているhairdresserのidであるレコードを作成した。
    def edit
        @style_image =  StyleImage.find_by(hairdresser_id: @current_hairdresser.id)
        @hair_arry = @style_image.hair_images
        gon.image_number = @style_image.hair_images.size 
    end

    def update
        @style_image_add = StyleImage.new(style_images_params)
        @style_image = StyleImage.find_by(hairdresser_id: @current_hairdresser.id)
        @style_image.hair_images.push(@style_image_add.hair_images) #新しく追加した画像の配列を加える 配列の中に配列が入っていることになる
        @style_image.hair_images.flatten! #配列の中の配列をなくす
        @style_image.save
        
        @destroy_arry_number = params[:arry]
        if @destroy_arry_number != nil
            @destroy_arry_number.each do |destroy_arry_number|
                @style_image.hair_images.delete_at(destroy_arry_number.to_i)
            end
            @style_image.save
        end
        redirect_to hairdresser_path(@current_hairdresser.id)
    end

    def destroy
        @class_number = params[:id].to_i
        @style_image =  StyleImage.find_by(hairdresser_id: @current_hairdresser.id)
        @image_array = @style_image.hair_images
        @image_array.delete_at(params[:id].to_i)
        @style_image.save
        #redirect_to edit_style_image_path(@style_image.id)
    end

    def destroy_preparation
        @hair_arry = params[:arry]
        @hair_arry.delete_at(params[:arry_number].to_i)
        @i = params[:arry_number].to_i
    end

    private
    def style_images_params
        params.require(:style_image).permit({hair_images:[]})
    end

end
