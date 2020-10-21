
[1mFrom:[0m /home/vagrant/work/portfolio/chokichoki/app/controllers/users_controller.rb:113 UsersController#edit:

    [1;34m111[0m: [32mdef[0m [1;34medit[0m [1;34m#アカウント設定[0m
    [1;34m112[0m:     binding.pry
 => [1;34m113[0m:     @user = [1;34;4mUser[0m.find(@current_user.id)
    [1;34m114[0m:     [32mif[0m params[[33m:profile[0m].present?
    [1;34m115[0m:         @profile = [1;36mtrue[0m
    [1;34m116[0m:     [32mend[0m
    [1;34m117[0m:     [32mif[0m params[[33m:password[0m].present?
    [1;34m118[0m:         @password = [1;36mtrue[0m
    [1;34m119[0m:     [32mend[0m
    [1;34m120[0m:     [32mif[0m params[[33m:credit[0m].present?
    [1;34m121[0m:         @card = [1;34;4mUserCard[0m.find_by([35muser_id[0m: @current_user.id)
    [1;34m122[0m:         [32mif[0m @card.present?
    [1;34m123[0m:             [1;34;4mPayjp[0m.api_key =[1;36mENV[0m[[31m[1;31m'[0m[31mSECRET_KEY[1;31m'[0m[31m[0m] [1;34m#秘密鍵[0m
    [1;34m124[0m:             customer = [1;34;4mPayjp[0m::[1;34;4mCustomer[0m.retrieve(@card.customer_id) [1;34m#payjpサイトの顧客情報を取得[0m
    [1;34m125[0m:             @card_information = customer.cards.retrieve(@card.card_id)  [1;34m#payjpサイトのカード情報を取得[0m
    [1;34m126[0m:             @credit = [1;36mtrue[0m
    [1;34m127[0m:         [32melse[0m
    [1;34m128[0m:             @credit = [1;36mfalse[0m
    [1;34m129[0m:         [32mend[0m
    [1;34m130[0m:     [32mend[0m 
    [1;34m131[0m:     [32mif[0m params[[33m:current_password[0m].present? && @user.authenticate(params[[33m:current_password[0m])
    [1;34m132[0m:         @current_password = [1;36mtrue[0m
    [1;34m133[0m:     [32melsif[0m params[[33m:current_password[0m].present? && @user.authenticate(params[[33m:current_password[0m]) == [1;36mfalse[0m || params[[33m:current_password[0m] == [31m[1;31m"[0m[31m[1;31m"[0m[31m[0m
    [1;34m134[0m:         @current_password = [1;36mfalse[0m
    [1;34m135[0m:     [32mend[0m
    [1;34m136[0m: [32mend[0m
