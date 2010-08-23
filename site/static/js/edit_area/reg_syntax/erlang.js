editAreaLoader.load_syntax["erlang"] = {
	'DISPLAY_NAME' : 'Erlang'
	,'COMMENT_SINGLE' : {1 : "%"}
	,'COMMENT_MULTI' : { }
	,'QUOTEMARKS' : {1: '"'}
	,'KEYWORD_CASE_SENSITIVE' : true
	,'KEYWORDS' : {
		'reserved' : [
			'after',  'begin',  
			'case', 'catch', 'cond', 'end', 'fun', 'if', 'let', 'of', 
			'query', 'receive', 'try', 'when'
		]
		,'bifs' : [
			'abs','adler32','adler32_combine','append_element','apply','atom_to_binary','atom_to_list','binary_part',
			'binary_to_atom','binary_to_existing_atom','binary_to_list','bitstring_to_list','binary_to_term',
			'bit_size','bump_reductions','byte_size','cancel_timer','check_process_code','concat_binary','crc32',
			'crc32_combine','date','decode_packet','delete_module','demonitor','disconnect_node','display','element',
			'erase','error','exit','float','float_to_list','fun_info','fun_to_list','function_exported','garbage_collect',
			'get','get_cookie','get_keys','get_stacktrace','group_leader','halt','hash','hd','hibernate','integer_to_list',
			'iolist_to_binary','iolist_size','is_alive','is_atom','is_binary','is_bitstring','is_boolean','is_builtin',
			'is_float','is_function','is_integer','is_list','is_number','is_pid','is_port','is_process_alive','is_record',
			'is_reference','is_tuple','length','link','list_to_atom','list_to_binary','list_to_bitstring','list_to_existing_atom',
			'list_to_float','list_to_integer','list_to_pid','list_to_tuple','load_module','load_nif','loaded','localtime',
			'localtime_to_universaltime','make_ref','make_tuple','max','md5','md5_final','md5_init','md5_update','memory',
			'min','module_loaded','monitor','monitor_node','nif_error','node','nodes','now','open_port','phash','phash2',
			'pid_to_list','port_close','port_command','port_connect','port_control','port_call','port_info','port_to_list',
			'ports','pre_loaded','process_display','process_flag','process_info','processes','purge_module','put','raise',
			'read_timer','ref_to_list','register','registered','resume_process','round','self','send','send_after','send_nosuspend',
			'set_cookie','setelement','size','spawn','spawn_opt','split_binary','start_timer','statistics','suspend_process',
			'system_flag','system_info','system_monitor','system_profile','term_to_binary','throw','time','tl','trace',
			'trace_delivered','trace_info','trace_pattern','trunc','tuple_size','tuple_to_list','universaltime','universaltime_to_localtime',
			'unlink','unregister','whereis','yield'
		]
		,'operators' : [
			'bnot', 'not', 'div', 'rem', 'band', 'and', 'bor','bxor','bsl','bsr','or','xor','andalso','orelse'
		]
	}
	,'OPERATORS' :[
		':', '#', '/', '*', '+', '-', '++', '--', '==', '/=','=<','<','>=','>','=:=','=/=','= !','=!'
	]
	,'DELIMITERS' :[
		'{', '}', '[', ']', '(', ')'
	]	
	,'REGEXPS' : {
		'vars' : {
			'search' : '( |\n|\r|\t|\\(|\\)|\\{|\\}|\\[|\\])([A-Z][A-Za-z0-9_]*)()'
			,'class' : 'vars'
			,'modifiers' : 'g'
			,'execute' : 'before'
		}
		,'head' : {
			'search' : '()([-][a-z0-9_]*)()'
			,'class' : 'head'
			,'modifiers' : 'g'
			,'execute' : 'before'
		}
	}
	,'STYLES' : {
		'COMMENTS': 'color: #892AFF;'
		,'QUOTESMARKS': 'color: #FF33FF;'
		,'KEYWORDS' : {
			'reserved' : 'color: #FF0000;'
			,'bifs' : 'color: #178DA4;'
			,'operators' : 'color: #FF0000;'
			}
		,'OPERATORS' : 'color: #FF0000;'
		,'DELIMITERS' : 'color: #0000FF;'
		,'REGEXPS' : {
			'vars' : 'color: #25D43D'
			,'head' : 'color: #A23AF7;'
		}
	}
};
