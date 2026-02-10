function txt_edit
    echo $EDITOR $argv
end
function jq_edit
    echo jless $argv
end
function csv_edit
    echo qsv $argv
end
function open_edit
    echo xdg-open $argv
end
function mcat_edit
    echo mcat $argv
end
abbr -a pdf_edit --position command --regex ".+\.pdf" --function open_edit
abbr -a md_edit --position command --regex ".+\.md" --function mcat_edit
abbr -a txt_edit --position command --regex ".+\.txt" --function txt_edit
abbr -a toml_edit --position command --regex ".+\.toml" --function txt_edit
abbr -a yaml_edit --position command --regex ".+\.yaml" --function txt_edit
abbr -a json_edit --position command --regex ".+\.json" --function jq_edit
abbr -a csv_edit --position command --regex ".+\.csv" --function csv_edit

function _which
    command --search (string sub --start=2 $argv)
end
abbr --add expand_which --regex '=\w+' --position anywhere --function _which
