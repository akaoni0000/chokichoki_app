
[1mFrom:[0m /home/vagrant/work/portfolio/chokichoki/app/controllers/admins_controller.rb:70 AdminsController#chart:

    [1;34m47[0m: [32mdef[0m [1;34mchart[0m
    [1;34m48[0m:     [1;34m# if params[:day][0m
    [1;34m49[0m:     [1;34m# else[0m
    [1;34m50[0m:     [1;34m#     @Time = Time.now[0m
    [1;34m51[0m:     [1;34m#     if @Time.day == 1 && (@Time.month == 4 || @Time.month == 6 || @Time.month == 9 || @Time.month == 11)[0m
    [1;34m52[0m:     [1;34m#         @pre_day = 31 [0m
    [1;34m53[0m:     [1;34m#     elsif @Time.day == 1 && @Time.month == 3 && @Time.year % 4 == 0[0m
    [1;34m54[0m:     [1;34m#         @pre_day = 29[0m
    [1;34m55[0m:     [1;34m#     elsif @Time.day == 1 && @Time.month == 3 && @Time.year % 4 != 0[0m
    [1;34m56[0m:     [1;34m#         @pre_day = 28[0m
    [1;34m57[0m:     [1;34m#     elsif @day == 1 [0m
    [1;34m58[0m:     [1;34m#         @pre_day = 31[0m
    [1;34m59[0m:     [1;34m#     end [0m
    [1;34m60[0m:     [1;34m#     @pre_month = @Time.month - 1[0m
    [1;34m61[0m:     [1;34m#     if @Time.day == 1 && @Time.month == 1[0m
    [1;34m62[0m:     [1;34m#         @pre_month = 12[0m
    [1;34m63[0m:     [1;34m#     end[0m
    [1;34m64[0m:     [1;34m# end[0m
    [1;34m65[0m:     i = [31m[1;31m"[0m[31m1[1;31m"[0m[31m[0m
    [1;34m66[0m:     [1;34m5[0m.times [32mdo[0m
    [1;34m67[0m:         [31m[1;31m"[0m[31mmonth#{i}[0m[31m[1;31m"[0m[31m[0m 
    [1;34m68[0m:     [32mend[0m
    [1;34m69[0m:     binding.pry
 => [1;34m70[0m: [32mend[0m

