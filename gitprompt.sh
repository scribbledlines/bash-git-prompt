#!/usr/bin/env bash

source 'gitprompt_core.sh'

function setGitPrompt() {

    getGitPrompt

}

# toggle gitprompt
function git_prompt_toggle() {
  if [[ "${GIT_PROMPT_DISABLE:-0}" = 1 ]]; then
    GIT_PROMPT_DISABLE=0
  else
    GIT_PROMPT_DISABLE=1
  fi
  return
}

function gp_install_prompt {
  if [[ -z "${OLD_GITPROMPT+x}" ]]; then
    OLD_GITPROMPT=${PS1}
  fi

  if [[ -z "${GIT_PROMPT_OLD_DIR_WAS_GIT+x}" ]]; then
    GIT_PROMPT_OLD_DIR_WAS_GIT=$(we_are_on_repo)
  fi

  if [[ -z "${PROMPT_COMMAND:+x}" ]]; then
    PROMPT_COMMAND=setGitPrompt
  else
    PROMPT_COMMAND="${PROMPT_COMMAND//$'\n'/;}" # convert all new lines to semi-colons
    PROMPT_COMMAND="${PROMPT_COMMAND#\;}" # remove leading semi-colon
    PROMPT_COMMAND="${PROMPT_COMMAND%% }" # remove trailing spaces
    PROMPT_COMMAND="${PROMPT_COMMAND%\;}" # remove trailing semi-colon

    local new_entry="setGitPrompt"
    case ";${PROMPT_COMMAND};" in
      *";${new_entry};"*)
        # echo "PROMPT_COMMAND already contains: $new_entry"
        :;;
      *)
        PROMPT_COMMAND="${PROMPT_COMMAND};${new_entry}"
        # echo "PROMPT_COMMAND does not contain: $new_entry"
        ;;
    esac
  fi

  local setLastCommandStateEntry="setLastCommandState"
  case ";${PROMPT_COMMAND};" in
    *";${setLastCommandStateEntry};"*)
      # echo "PROMPT_COMMAND already contains: $setLastCommandStateEntry"
      :;;
    *)
      PROMPT_COMMAND="${setLastCommandStateEntry};${PROMPT_COMMAND}"
      # echo "PROMPT_COMMAND does not contain: $setLastCommandStateEntry"
      ;;
  esac

  git_prompt_dir
  source "${__GIT_PROMPT_DIR}/git-prompt-help.sh"
}

gp_install_prompt
