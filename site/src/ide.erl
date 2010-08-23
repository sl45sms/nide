-module(ide).

-compile(export_all).

-include_lib("nitrogen/include/wf.hrl").

-include("records.hrl").

main() -> #template{file ="./site/templates/ide.html"}.

title() -> "Nitrogen Web Ide".

metatags() -> "".

scripts() -> "
	<script language=\"Javascript\" type=\"text/javascript\">
		// initialisation
		editAreaLoader.init({
			id: \"editor\"	// id of the textarea to transform		
			,start_highlight: true	// if start with highlight
			,allow_resize: \"both\"
			,allow_toggle: true
			,word_wrap: true
			,language: \"en\"
			,syntax: \"erlang\"
			,show_line_colors: true	
		});
	</script>
<script language=\"Javascript\" type=\"text/javascript\" class=\"source\"> 
$.jstree._themes = \"images/jstree/themes/\";
$(function () {
	$(\".wfid_treelist\").jstree({ 
		\"plugins\" : [ \"themes\",\"ui\",\"html_data\" ]
	});
});
</script>
<script language=\"Javascript\" type=\"text/javascript\" class=\"source\"> 

$(document).ready(function () {

$('.wfid_container').layout({ 

   defaults: {
      
   }
,  west: {
      fxName:               \"slide\"
   ,  fxSpeed:               \"slow\"
   ,  spacing_closed:        14
   ,  initClosed:            true
   }
,  north: {
      size : 		    \"auto\"
   ,  resizable : false 
   ,  fxName:               \"none\"
   ,  spacing_closed:        8
   ,  togglerLength_closed:  \"100%\"
   }
,  south: {
      fxName:                \"slide\"
   ,  spacing_closed:        14
   ,  initClosed:            true
   }
 });

$('.wfid_tab1').attr('id','tab1');//Do not change the order for the folowing
$('.wfid_tab2').attr('id','tab2');//or else
$('.wfid_tabs').tabs();           //tabs dont work

});	
</script> 
".

style() ->"<link rel=\"stylesheet\" href=\"/css/ide.css\">".

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% auxiliary routines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%>>> 
%generate_jstree_listing
%generates file listing recursively with Accumulator "ListTree" holding the ul li lists        
%<<<
generate_jstree_htmllisting(Dir) ->
  case file:list_dir(Dir) of
      {ok, ListTree} -> add_jstree_list(Dir, ListTree,[""]);
       _ -> wf:error("generate_file_listing -> Unable to read directory"), []
   end.


add_jstree_list(_, [], ListTreeWithType) -> ListTreeWithType;
add_jstree_list(Dir, [H | T], ListTreeWithType) ->
  case file:read_link_info(Dir ++ "/" ++ H) of 
      {ok, {_,_,FileType,_,_,_,_,_,_,_,_,_,_,_}} ->
   case FileType of                                     %TODO fix crash if file don't have extencion 
       regular -> 
                 FileID= wf:temp_id(),
                  wf:wire(FileID, #event { type=click, postback={open_file,Dir++"/"++H} }), 
                 add_jstree_list(Dir, T, ["<li class=\""++ string:substr(filename:extension(H), 2)++" wfid_"++FileID++"\" ><a class=\""++ string:substr(filename:extension(H), 2)++"\" href=\"#\">" ++ H ++ "</a></li>"++io_lib:nl() | ListTreeWithType]);
       
          directory -> add_jstree_list(Dir, T, ListTreeWithType ++ "<ul><li><a class=\"dir\" href=\"#\">"++ H ++ "</a>"++io_lib:nl()++"<ul>" ++ generate_jstree_htmllisting(Dir ++ "/" ++ H)++"</ul></li></ul>");
       _ -> add_jstree_list(Dir, T, ListTreeWithType)
    end;   
    _ ->
    wf:error("add_file_list -> Could not read file"),
    add_jstree_list(Dir, T, ListTreeWithType)
    end.

get_jstree_list(Dir)->
wf:f("<ul><li><a class=\"dir\" href=\"#\">~s</a><ul>~s</ul></li></ul>",[filename:basename(Dir),lists:flatten([generate_jstree_htmllisting(Dir)])]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% appear %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%>>>
%show
%This block shows the content of page for the current language.
%If the user is logged in and have the rights to edit this page then show an edit button at the end of page.
%<<<
body() ->
  Body =[#flash{},
    #hidden{id="hidden_data",text=""},%use this to hold the data before save
    #hidden{id="hidden_path",text=""},%use this to hold the path of file before save
    #hidden{id="hidden_checkbox",text="checked"},%Workaround to bug of checkbox


#panel {id="container",body=[
%%Top - North
    #panel {id="topbuttons", class="ui-layout-north", body=[ 
                  #button { text="Refresh Tree", postback=refresh_tree },   
                  #button { text="Save Current",actions=
                      #event{type=click,                  
                      actions="var f=editAreaLoader.getCurrentFile('editor');var  Path=f.id; var Content = f.text; $('.wfid_hidden_data').attr('value', Content);$('.wfid_hidden_path').attr('value', Path); editAreaLoader.setFileEditedMode('editor', f.id, 0);",postback=save_current}}, 
    #button { text="Compile!", postback=compile },
    #checkbox { id=compileonsave, text="Compile On Save", value="checked", checked=true,
    actions=#event{type=click,actions="if ($('.wfid_hidden_checkbox').val()=='checked') {$('.wfid_hidden_checkbox').attr('value', 'unchecked');} else {$('.wfid_hidden_checkbox').attr('value', 'checked');};"}} %#checkbox have bug!  
     ]},
     
%Tree - West
    #panel { id="tree", class="wfid_treelist ui-layout-west", body=[get_jstree_list("./site/src")]},


%Footer - South    
    #panel {id="footer", class="ui-layout-south",body=[
   
   #panel {id="tabs",body=[#list{body=[#listitem{body=[#link {text="Commands Log",url="#tab1",id="tablink"}]},#listitem{body=[#link { text="Report Log",url="#tab2",id="tablink"}]}]},
   #panel {id="tab1",body=[#textarea{id="cmdlog", text="Executed commands Log\n"}]},
   #panel {id="tab2",body=[#textarea{id="reportlog", text="Report Log\n"}]}
    ]}
   
    ]},

%Left - East    
 %   #panel {id="left",class="ui-layout-east",body=[""]},    
 
%Editor- Center
    #panel {id="editarrea", class="ui-layout-center", body=["<textarea id=\"editor\" class=\"wfid_editor editor\" name=\"editor\"></textarea>"]}
 ]}
      ],
       wf:comet(fun()-> inittail(fun display_tail/1) end),
       Body.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% events %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
event(compile)->
ExecTime = httpd_util:rfc1123_date(erlang:localtime()),
wf:insert_bottom("cmdlog","("++ExecTime++") Execute Compile:\n"++os:cmd("./bin/dev compile")++"\n");

event(refresh_tree)->
wf:info("tst"++wf:temp_id()),
wf:wire("$(\".wfid_treelist\").jstree('destroy');"),
wf:update("tree",get_jstree_list("./site/src")),
wf:wire("$(\".wfid_treelist\").jstree({\"plugins\" : [ \"themes\",\"ui\",\"html_data\" ]})");


event(save_current)->
Content = wf:qs("hidden_data"),
Path = wf:qs("hidden_path"),
Compile = wf:f("~s",[wf:qs("hidden_checkbox")]),
file:write_file(Path,Content),%TODO check if file is writed, make backup before save
if Compile == "checked" -> wf:insert_bottom("cmdLog","File saved, compile:\n"),event(compile); 
true->wf:insert_bottom("cmdLog","File saved but not compiled\n") end;  

%>>>
%file clicked on tree for open
%<<<
event({open_file,Path}) ->
  {ok,FileContents} = file:read_file(Path),
%   wf:wire(   wf:f("editAreaLoader.setValue(\"editor\",\"~s\");",[wf:js_escape(FileContents)]) ).
wf:wire(   wf:f("editAreaLoader.openFile(\"editor\",{id: \"~s\", text: \"~s\", syntax: 'erlang',title: '~s'});",[Path,wf:js_escape(FileContents),filename:basename(Path)] ) ).

%REPORT LOG
tail_loop(Port, Callback) ->
receive
		{Port, {data, {eol, Bin}}} -> Callback(Bin),tail_loop(Port, Callback);
		{Port, {data, {noeol, Bin}}} -> Callback(Bin),tail_loop(Port, Callback);
		{Port, {data, Bin}} -> Callback(Bin), tail_loop(Port, Callback);
		{Port, {exit_status, Status}} ->{ok, Status};
		{Port, eof} ->port_close(Port),{ok, eof};
		{snap, Who} ->	Who ! { Port, Callback},tail_loop(Port, Callback);
		stop ->	port_close(Port),{ok, stop};
		_Any ->	tail_loop(Port, Callback) 
end.

inittail(Callback) ->
	Cmd = "/usr/bin/tail -f ./log/report.log",
	Port = open_port({spawn, Cmd}, [ stderr_to_stdout, {line, 256}, exit_status, binary]), 
	tail_loop(Port, Callback).

display_tail(Content) ->
	wf:insert_bottom("reportlog",wf:f("~s~n",[Content])),
	wf:flush().
