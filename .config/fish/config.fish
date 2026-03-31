function fish_greeting                                            
    # do nothing
    fastfetch
end 

set -g fish_color_normal A0A0A0
set -g fish_color_command B5E354
set -g fish_color_quote FEED6B
set -g fish_color_redirection 9D6EFE
set -g fish_color_end 8B54FE
set -g fish_color_error F92571
set -g fish_color_param 889BA1
set -g fish_color_comment 505354
set -g fish_color_match --background=505354
set -g fish_color_selection --background=505354
set -g fish_color_search_match --background=505354
set -g fish_color_operator 8B54FE
set -g fish_color_escape 465456
set -g fish_color_autosuggestion 505354
set -g fish_color_cwd 0B72C1
set -g fish_color_user B5E354
set -g fish_color_host A0A0A0
set -g fish_color_status F92571
set -g fish_color_valid_path --underline
if status is-interactive
    starship init fish | source
end
set -gx STARSHIP_CONFIG ~/.config/starship/config.toml
alias dotsync="git add .; and git commit -m 'update '(date +%H:%M); and git push"