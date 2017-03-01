function filetool

% Copyright (c) 1996 Philipos C. Loizou

global HDRSIZE Srate DWNS SWAPB UPS
global sfHndl hdrHndl cnvFig swpbHndl dwnHnd upHnd

pos = get(0, 'screensize');
wi=350; 
he=180;
ypos=(pos(4)-he)/2;
xpos=(pos(3)-wi)/2;

	cnvFig = figure('Units', 'pixels', 'Position', [xpos ypos wi he],...
	'Menubar','none','NumberTitle','off','Name',...
	'File Utility');

if isempty(HDRSIZE)
  HDRSIZE=512;
  Srate=20000;
end

if isempty(SWAPB)
  SWAPB=0;
  DWNS=1;
  UPS=1;
end
%---------------- Define the buttons-----------------------
dp=35; % he/5
top=he-dp;
inc=30;
lft=dp;
wit=65;



top=top-inc;
uicontrol('Style','Text','String','文件头大小 (bytes)','Position',[12 top 75 27],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','y');

hdrHndl=uicontrol('Style','edit','String',int2str(HDRSIZE),'Position',[12+75 top 50 20],...
	'Callback','convtool(''header2'')','BackgroundColor',[1 1 1]);

uicontrol('Style','Text','String','采样率(Hz)','Position',[20+12+2*wit top wit 27],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','y');

sfHndl=uicontrol('Style','edit','String',int2str(Srate),'Position',[lft+12+3*wit top 50 20],...
	'Callback','convtool(''sfreq2'')','BackgroundColor',[1 1 1]);

top=top-inc;
swpbHndl=uicontrol('Style','CheckBox','String','交换字节','Position',[12 top 80 20],...
	'Callback','convtool(''swap'')','ForeGroundColor','y','BackgroundColor',[0 0 0]);

uicontrol('Style','Frame','Position',[115 top-inc-10 140 65],...
	'BackGroundColor','b');

dwnHnd=uicontrol('Style','Popup','String','no|2|3|4','Position',[120 top 50 20],...
	'Callback','convtool(''down'')');

uicontrol('Style','Text','String','采样（下图）','Position',[175 top-7 70 27],'BackgroundColor',...
	 'b','ForeGroundColor','y');

top=top-inc;
upHnd=uicontrol('Style','Popup','String','no|2|3|4','Position',[120 top 50 20],...
	'Callback','convtool(''up'')');

uicontrol('Style','Text','String','采样（上图）','Position',[175 top-7 70 27],'BackgroundColor',...
	 'b','ForeGroundColor','y');

% ----- start now a new column of buttons--------------------

wit2=75;
z=10;
lft=(wi-3*wit2-2*z)/2;

top=top-inc-20;
uicontrol('Style','pushb','String','应用','Position',[lft top wit2 20],...
	'Callback','convtool(''apply'')');


uicontrol('Style','pushb','String','取消','Position',[lft+wit2+z top wit2 20],...
	'Callback','delete(gcf)');

uicontrol('Style','pushb','String','帮助','Position',[lft+2*wit2+2*z top wit2 20],...
	'Callback','helpf(''fileutil'')');
