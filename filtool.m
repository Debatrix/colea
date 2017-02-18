function filtool

% Copyright (c) 1995 Philipos C. Loizou

global nChannels filename bvi avi Srate 
global HDRSIZE S0 S1  En Be Dur n_Secs MAX_AM fno
global HDRSIZE2 Srate2 n_Secs2 filename2 TOP TWOFILES agcsc2
global filtFig lpfF lpfN fcLPF nuLPF hpfF hpfN fcHPF nuHPF
global bpfF1 bpfF2 bpfN fc1BPF fc2BPF nuBPF filtFig


pos = get(0, 'screensize');

wi=356; 
he=210; 
xpos=(pos(3)-wi)/2; 
ypos=(pos(4)-he)/2;

if isempty(filtFig)
	filtFig = figure('Units', 'pixels', 'Position', [xpos ypos wi he],...
	'Menubar','none','NumberTitle','off','Name',...
	'滤波器');
else
	figure(filtFig);
	if ~isempty(lpfF); return; end;
end

%---------------- Initialize  default cutoff frequencies, number of coeffs, etc-----
%----------------               初始化默认截断频率，非零系数等                   -----
if isempty(fcLPF)
	fcLPF=1000;
	nuLPF=4;
	fcHPF=1000;
	nuHPF=4;
	fc1BPF=100;
	fc2BPF=1000;
	nuBPF=3;
end

%---------------- Define the buttons for Low-Pass Filter-----------------------
dp=35; 
top=165; 
inc=30;
lft=dp;
wit=65; 

uicontrol('Style','Text','String','低通','Position',[lft+12 he-15 wit 27],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','r');

uicontrol('Style','Text','String','截断','Position',[3 top lft+7 20],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','y');
lpfF=uicontrol('Style','edit','String',int2str(fcLPF),'Position',[lft+12 top wit 20],...
	'Callback','filtpar(''LPF'',''freq'')','BackgroundColor',[1 1 1]);
top=top-inc;
uicontrol('Style','Text','String','阶数','Position',[3 top lft 20],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','y');
lpfN=uicontrol('Style','edit','String',int2str(nuLPF),'Position',[lft+12 top wit 20],...
	'Callback','filtpar(''LPF'',''coeff'')','BackgroundColor',[1 1 1]);
lft=lft+12;
top=top-inc;
uicontrol('Style','pushb','String','查看滤波器','Position',[lft-10 top wit+15 20],...
	'Callback','apfilter(''LPF'',''view'')');
top=top-inc;
uicontrol('Style','pushb','String','应用滤波器','Position',[lft-10 top wit+15 20],...
	'Callback','apfilter(''LPF'',''apply'')');


%---------------- Define the buttons for High-Pass Filter-----------------------
top=he-dp-10;
inc=30;
lft=lft-10+wit+15+3;

uicontrol('Style','Text','String','高通','Position',[lft he-15 wit+7 27],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','r','HorizontalALignment','left');


hpfF=uicontrol('Style','edit','String',int2str(fcHPF),'Position',[lft top wit 20],...
	'Callback','filtpar(''HPF'',''freq'')','BackgroundColor',[1 1 1]);
top=top-inc;

hpfN=uicontrol('Style','edit','String',int2str(nuHPF),'Position',[lft top wit 20],...
	'Callback','filtpar(''HPF'',''coeff'')','BackgroundColor',[1 1 1]);
top=top-inc;
uicontrol('Style','pushb','String','查看滤波器','Position',[lft top wit+10 20],...
	'Callback','apfilter(''HPF'',''view'')');
top=top-inc;
uicontrol('Style','pushb','String','应用滤波器','Position',[lft top wit+15 20],...
	'Callback','apfilter(''HPF'',''apply'')');
 
top=top-inc;

%---Draw the close button-----------
uicontrol('Style','pushb','String','关闭','Position',[lft-5 5 wit+18 20],...
	'Callback','closem(''filtFig'')');

uicontrol('Style','pushb','String','帮助','Position',[lft-5+wit+25 5 wit+18 20],...
	'Callback','helpf(''filtool'')');

%------------ Define the buttons for Band-Pass Filter-----------------------
top=he-dp-10;
inc=30;
lft=lft+wit+15;

%h=uicontrol('Style','Frame','Position',[lft top-4*inc wi-lft+10 he-3]);
uicontrol('Style','Text','String','低','Position',[lft top wit-5 20],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','y');
uicontrol('Style','Text','String','高','Position',[lft top-inc wit-5 20],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','y');
uicontrol('Style','Text','String','阶数','Position',[lft top-2*inc wit-5 20],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','y');
lft=lft+wit-5+1;
uicontrol('Style','Text','String','带通','Position',[lft-25 he-15 wit+10 27],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','r');

bpfF1=uicontrol('Style','edit','String',int2str(fc1BPF),'Position',[lft top wit 20],...
	'Callback','filtpar(''BPF'',''freq1'')','BackgroundColor',[1 1 1]);
top=top-inc;
bpfF2=uicontrol('Style','edit','String',int2str(fc2BPF),'Position',[lft top wit 20],...
	'Callback','filtpar(''BPF'',''freq2'')','BackgroundColor',[1 1 1]);
top=top-inc;

bpfN=uicontrol('Style','edit','String',int2str(nuBPF),'Position',[lft top wit 20],...
	'Callback','filtpar(''BPF'',''coeff'')','BackgroundColor',[1 1 1]);
top=top-inc;
uicontrol('Style','pushb','String','查看滤波器','Position',[lft-5 top wit+18 20],...
	'Callback','apfilter(''BPF'',''view'')');
top=top-inc;
uicontrol('Style','pushb','String','应用滤波器','Position',[lft-5 top wit+18 20],...
	'Callback','apfilter(''BPF'',''apply'')');


