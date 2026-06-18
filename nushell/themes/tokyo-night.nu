# Tokyo Night color theme for Nushell
# Palette: https://github.com/enkia/tokyo-night-vscode-theme
export def main [] {
    return {
        binary: '#bb9af7'
        block: '#7aa2f7'
        cell-path: '#c0caf5'
        closure: '#2ac3de'
        custom: '#c0caf5'
        duration: '#e0af68'
        float: '#ff9e64'
        glob: '#c0caf5'
        int: '#bb9af7'
        list: '#2ac3de'
        nothing: '#f7768e'
        range: '#e0af68'
        record: '#7aa2f7'
        string: '#9ece6a'

        bool: {|| if $in { '#9ece6a' } else { '#f7768e' } }

        datetime: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#f7768e' attr: 'b' }
            } else if $in < 6hr {
                '#ff9e64'
            } else if $in < 1day {
                '#e0af68'
            } else if $in < 3day {
                '#9ece6a'
            } else if $in < 1wk {
                { fg: '#7dcfff' attr: 'b' }
            } else if $in < 6wk {
                '#7aa2f7'
            } else if $in < 52wk {
                '#bb9af7'
            } else { 'dark_gray' }
        }

        filesize: {|e|
            if $e == 0b {
                '#565f89'
            } else if $e < 1mb {
                '#7dcfff'
            } else {{ fg: '#7aa2f7' attr: 'b' }}
        }

        shape_and: { fg: '#bb9af7' attr: 'b' }
        shape_binary: { fg: '#bb9af7' attr: 'b' }
        shape_block: { fg: '#7aa2f7' attr: 'b' }
        shape_bool: '#9ece6a'
        shape_closure: { fg: '#2ac3de' attr: 'b' }
        shape_custom: '#c0caf5'
        shape_datetime: { fg: '#7dcfff' attr: 'b' }
        shape_directory: '#7aa2f7'
        shape_external: '#c0caf5'
        shape_external_resolved: '#9ece6a'
        shape_externalarg: { fg: '#c0caf5' attr: 'b' }
        shape_filepath: '#7aa2f7'
        shape_flag: { fg: '#bb9af7' attr: 'b' }
        shape_float: { fg: '#ff9e64' attr: 'b' }
        shape_garbage: { fg: '#1a1b26' bg: '#f7768e' attr: 'b' }
        shape_glob_interpolation: { fg: '#2ac3de' attr: 'b' }
        shape_globpattern: { fg: '#2ac3de' attr: 'b' }
        shape_int: { fg: '#bb9af7' attr: 'b' }
        shape_internalcall: { fg: '#7aa2f7' attr: 'b' }
        shape_keyword: { fg: '#bb9af7' attr: 'b' }
        shape_list: { fg: '#2ac3de' attr: 'b' }
        shape_literal: '#c0caf5'
        shape_match_pattern: '#9ece6a'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#f7768e'
        shape_operator: '#e0af68'
        shape_or: { fg: '#bb9af7' attr: 'b' }
        shape_pipe: { fg: '#bb9af7' attr: 'b' }
        shape_range: { fg: '#e0af68' attr: 'b' }
        shape_raw_string: { fg: '#9ece6a' attr: 'b' }
        shape_record: { fg: '#7aa2f7' attr: 'b' }
        shape_redirection: { fg: '#bb9af7' attr: 'b' }
        shape_signature: { fg: '#7aa2f7' attr: 'b' }
        shape_string: '#9ece6a'
        shape_string_interpolation: { fg: '#2ac3de' attr: 'b' }
        shape_table: { fg: '#7aa2f7' attr: 'b' }
        shape_vardecl: { fg: '#7aa2f7' attr: 'u' }
        shape_variable: '#bb9af7'

        foreground: '#c0caf5'
        background: '#1a1b26'
        cursor: '#c0caf5'

        empty: '#565f89'
        header: { fg: '#7aa2f7' attr: 'b' }
        hints: '#565f89'
        leading_trailing_space_bg: { attr: 'n' }
        row_index: { fg: '#7dcfff' attr: 'b' }
        search_result: { fg: '#1a1b26' bg: '#7aa2f7' }
        separator: '#414868'
    }
}

# Update the Nushell configuration
export def --env "set color_config" [] {
    $env.config.color_config = (main)
}

# Update terminal colors
export def "update terminal" [] {
    let theme = (main)

    let osc_screen_foreground_color = '10;'
    let osc_screen_background_color = '11;'
    let osc_cursor_color = '12;'

    $"
    (ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)
    (ansi -o $osc_screen_background_color)($theme.background)(char bel)
    (ansi -o $osc_cursor_color)($theme.cursor)(char bel)
    "
    | str replace --all "\n" ''
    | print -n $"($in)\r"
}

export module activate {
    export-env {
        set color_config
        update terminal
    }
}

# Activate the theme when sourced
use activate
