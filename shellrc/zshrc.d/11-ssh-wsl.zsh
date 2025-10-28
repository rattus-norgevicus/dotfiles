if uname -r | grep -q 'microsoft'; then
	local ssh_pid=$(pidof ssh-agent) 
	if [ "$ssh_pid" = "" ]; then
		ssh_env="$(ssh-agent -s)"
		echo "$ssh_env" | head -n 2 | tee ~/.ssh_agent_env > /dev/null
	fi

	if [ -f ~/.ssh_agent_env ]; then
		eval "$(cat ~/.ssh_agent_env)"
		ssh-add ~/.ssh/github &>/dev/null
	fi
fi

