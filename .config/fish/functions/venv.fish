begin
	function _remove_venv
		if test -d $VIRTUAL_ENV_DIR
			rm -rf $VIRTUAL_ENV_DIR
		else
	 		echo -s (set_color yellow) "No venv ($VIRTUAL_ENV_DIR directory) found" (set_color normal)
		end
	end

	function _create_venv
		command python3 -m venv $VIRTUAL_ENV_DIR
		and activate -v
		and pip install -U pip setuptools wheel
	end

	function _reset_venv
		_remove_venv
		_create_venv
	end

	function venv -d 'Handy wrapper for `python3 -m venv`'
		if contains -- --rm $argv
			_remove_venv
		else
			if contains -- --reset $argv
				_reset_venv
			else
				_create_venv
			end

			# if contains -- --install-requirements $argv
			# 	pip install -r ./requirements.txt
			# end
		end
	end
end
