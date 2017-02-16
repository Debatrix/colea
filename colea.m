function colea(infile,Srate1)

% COLEA主程序
% 程序入口 
% 绘制程序主窗体
% 允许命令行打开




colordef none  % 在MATLAB 4.x中注释掉该行（早就没有4.x了）

global hl hr doit
global fed shW
global filename
global fno Srate n_Secs filename AXISLOC  nLPC HDRSIZE
global nChannels fftSize filterWeights UpperFreq LowFreq ChanpUp
global center LPCSpec SpecUp Dur DurUp filterA filterB  S1 S0
global HDRSIZE cAxes En Be TIME centSMSP Asmsp Bsmsp OVRL WAV1 CLR
global TWOFILES wav agcsc MAX_AM upFreq upFreq2 FIX_SCALE
global SHOW_CRS SHOW_CHN ftype ftype2 bpsa bpsa2 PREEMPH LPC_ONLY
global lpcParam fft_par NAR_BAND SPEC_EXP FILT_TYPE VOL_MAX
global VOL_NORM
global sli n_samples FFT_SET XFFT
global tpc boc
global smp frq TOP
global preUp  defUp w64Up w128Up w256Up w512Up narUp
global crsUp chnUp lpcUp chnlpUp fbrd fnar
global ovlpfilt SET_X_AXIS LD_LABELS



%载入语音文件（窗口或命令）
if (nargin < 1)
 [pth,fname] = dlgopen('open','*.ils;*.wav');
 if ((~isstr(fname)) | ~min(size(fname))), return; end  
 filename=[pth,fname];
else
  filename=infile;
end
pos = get(0, 'screensize'); % 获取显示器尺寸
sWi = pos(3);
sHe = pos(4);
%设置默认窗口大小
WIDTH   =round(0.9375*sWi);
HEIGHT  =round(0.43*sHe) ;
LEFT    =round(0.025*sWi);
BOTTOM  =round(sHe-HEIGHT-40);
%载入默认设置
LPCSpec = 1;            % if 0 display FFT, else LPC spectrum
TIME=1;                 % if 0 display spectrogram, else time waveform
WAV1=0;                 % If 1, then it is a .wav file with 8 bits/sample
CLR=1;                  % If 1 display spectrogram in color, else in gray scale
TWOFILES=0;             % If 1, then display two files
wav(1)=0; wav(2)=0;     % Used in case of dual-displays for 1-byte samples, as in WAV
upFreq=1.0;             % Upper frequency (percentage of Srate/2) in spectrogram
upFreq2=1.0;            % Upper frequency in spectrogram (1.0=Srate/2)
FIX_SCALE=-1;           % if > 0, then channel y-axis is always 0-15 dB
SHOW_CRS=1;             % if 1, show cursor lines, else dont
SHOW_CHN=1;             % if 1, show channel output/LPC display
PREEMPH=1;              % if 1, do pre-emphasis when computing the  spectrogram
LPC_ONLY=1;             % if 1, only the LPC specrtrum is displayed
lpcParam(1)=1;          % if 1, use hamming window in LPC analysis, else use rectangular 
lpcParam(2)=0;          % if 1, first-order pre-emphasis in LPC analysis, else dont
			% NOTE: this pre-emphasis is done in addition to the CIS pre-emphasis
lpcParam(3)=-1;         % if 1, enhance spectral peaks in LPC analysis
fft_par(1)=1;           % if 1, use lines when plotting FFT, else use pickets
fft_par(2)=1;           % if 1 use hamming window, else rectangular
NAR_BAND=0;             % if 1, display narrowband spectrograms
SPEC_EXP=0.25;		% Used in spectrogram display (root compression)
FILT_TYPE='broad';	% the filter type
VOL_MAX=0;		% used for controling the volume
VOL_NORM=1;		% if 1, then volume is normalized
FFT_SET=0;		% if 1, use user defined FFT size
XFFT=0;			% same as above
SET_X_AXIS=0;
ovlpfilt=0;
LD_LABELS=0;
TOP=0;
%文件打开
fp = fopen(filename,'r');

if fp <=0
	disp('错误！文件未找到..')
	return;
end

ftype='short'; bpsa=2;    % 每个采样点的bytes
ftype2='short'; bpsa2=1;
%获取扩展名
ind1=find(filename == '.');
if length(ind1)>1, ind=ind1(length(ind1)); else, ind=ind1; end;
ext = lower(filename(ind+1:length(filename))); 



%获取文件头信息
[HDRSIZE, xSrate, bpsa, ftype] =  gethdr(fp,ext);

%读取音频数据
if xSrate==0, return; 
else Srate=xSrate; end;

if strcmp(ftype,'ascii')
 x=fscanf(fp,'%f',inf);
else
 x  = fread(fp,inf,ftype);
end
%x应该是采样点 Srate是采样率
	


fclose(fp); 
%设置默认采样率
if Srate<6000 | Srate>45000 & nargin<2
h=warndlg('采样率不在范围内: 10,000 < F < 45,000 . 请设置到  10,000 Hz.','警告!');
  disp('警告! 采样率不在范围内: 6,000 < F < 45,000');
  disp('...设置默认值为 10,000 Hz.');
  Srate=10000;
end    


%消除直流分量
x= x - mean(x);  

if (nargin==2)
 Srate  = str2num(Srate1);
 if Srate<10000 | Srate>45000
	error('指定的采样频率无效: 10,000<F<45,000');
 end
end

MAX_AM=2048; % 这允许12位分辨率

mx=max(x);
agcsc=MAX_AM/mx;


n_samples = length(x);%采样点数
n_Secs    = n_samples/Srate;%音频时长
Dur=10.0;   % 时间窗（毫秒）
S1=n_samples;
S0=0;
Be=S0;
En=S1;
OVRL=1;  % if 1 then hold off plots, else hold on plots in 'pllpc'

fprintf('采样率: %d Hz,  采样点数: %d (%4.2f 秒)\n',Srate,n_samples,n_Secs);
%绘制窗口
fno =  figure('Units', 'Pixels', 'Position', [LEFT BOTTOM WIDTH HEIGHT],...
	'WindowButtonDownFcn','mclick',...
	'Resize','on','Name',filename,'NumberTitle','Off',...
	'Menubar','None','WindowButtonMotionFcn','showpt',...
	'KeyPressFcn','getkb','Color','k');
		       
%------------ 确定坐标轴尺寸 ------------
%绘制轴
le=round(0.2*WIDTH);
bo=round(0.174*HEIGHT);
wi=round(0.773*WIDTH);
he=round(0.739*HEIGHT);

AXISLOC = [le bo wi he];
cAxes = axes('Units','Pixels','Position',AXISLOC);


axes(cAxes);



	Et=1000*n_samples/Srate;
	xax=0:1000/Srate:(Et-1000/Srate);
	
	plot(xax,x,'y')
	xlabel('时间 (msecs)');
	ylabel('振幅');
	set(gca,'Color','k'); set(gca,'Xcolor','w'); set(gca,'YColor','w');
	%set(gca,'Units','points','FontSize',9);
	if min(x)<-1000 | mx >1000
	  axis([0 Et min(x)-200 max(x)+200]);
	else
	  axis([0 Et min(x) max(x)]);
	end
            
   %set(gca,'Color','k');
   set(gca,'XColor','w');
   set(gca,'YColor','w');
xywh = get(fno, 'Position'); %获得当前鼠标位置
axi=AXISLOC;

% Buttons.
left = 10;
wide = 80;
top  = xywh(4) - 10;
high = 22;
high=22;
if 9*(22+8) > xywh(4), high=17; end;
inc  = high + 8;
%---------- 显示滑动条与按钮-------------
sli = uicontrol('Style','slider','min',0,'max',1000','Callback',...
	'getslide','Position',[axi(1) axi(2)+axi(4)+2 axi(3) 12]);
%getslide 波形图上方滑动条


%zoomi  放大按钮和缩小按钮
Zin = uicontrol('Style', 'PushButton', 'Callback','zoomi(''in'')', ...
	 'HorizontalAlign','center', 'String', '缩小',...
	 'Position', [left top-high wide high]);

top = top - inc;
Zout = uicontrol('Style', 'PushButton', 'Callback','zoomi(''out'')', ...
	 'HorizontalAlign','center', 'String', '放大',...
	 'Position', [left top-high wide high]);
if Srate>12000
  nLPC=14;
else
 nLPC=12; % 初始化LPC阶数
end
top = top - inc-20;
uicontrol('Style','Frame','Position',[left top-high-10 wide+5 high+30],...
	'BackgroundColor','b');
 
uicontrol('Style','text','Position',[left+wide/3 top 40 high-3],'BackGroundColor','b',...
	'HorizontalAlignment','left','ForeGroundColor','w','String','播放');

plUp = uicontrol('Style', 'PushButton', 'Callback', 'playf(''all'')', ...
	  'HorizontalAlign','center', 'String', '全部',...
	  'Position', [left top-high wide/2 high]);

uicontrol('Style', 'PushButton', 'Callback', 'playf(''sel'')', ...
	  'HorizontalAlign','center', 'String', '显示全部',...
	  'Position', [left+wide/2+5 top-high wide/2 high]);
%playf 播放按钮们
  
%---Draw the squares in case its TWOFILES
wwi=xywh(3); whe=xywh(4);%获得鼠标位置
tpc=uicontrol('Style','text','Position',[wwi-10 2*whe/3+10 10 10],'String',' ','BackGroundColor',[0 0 0]);
boc=uicontrol('Style','text','Position',[wwi-10 whe/3-10 10 10],'String',' ','BackGroundColor',[0 0 0]);


%----Draw the time and freq numbers----------
smp=uicontrol('Style','text','Position',[10 30 wide+10 15],'BackGroundColor',[0 0 0],...
	'HorizontalAlignment','left');
frq=uicontrol('Style','text','Position',[10 10 wide+10 15],'BackGroundColor',[0 0 0],...
	'HorizontalAlignment','left');


%
%-------------------------MENUS---------------------------------卧槽这个翻译不下去了
%
ff=uimenu('Label','文件');
   uimenu(ff,'Label','载入','Callback','loadfile(''stack'')');
   uimenu(ff,'Label','载入并替代','Callback','loadfile(''replace'')');
   uimenu(ff,'Label','保存整个文件','Callback','savefile(''whole'')','Separator','on');
   uimenu(ff,'Label','保存选中的区域','Callback','savefile(''seg'')');
   uimenu(ff,'Label','在光标处插入文件','CallBack','editool(''insfile'')','Separator','on');
   uimenu(ff,'Label','文件应用','Callback','filetool');
   uimenu(ff,'Label','绘制图形','Callback','cprint(''landscape'',''printer'')','Separator','on');
   uimenu(ff,'Label','绘制模型','Callback','cprint(''portrait'',''printer'')');
   fprf=uimenu(ff,'Label','绘制到文件 ...');
	uimenu(fprf,'Label','Postscript','Callback','cprint(''landscape'',''eps'')');
	uimenu(fprf,'Label','Windows metafile','Callback','cprint(''landscape'',''meta'')');


   uimenu(ff,'Label','退出','CallBack','quitall','Separator','on');

fed=uimenu('Label','编辑');
    uimenu(fed,'Label','剪切','CallBack','editool(''cut'')');
    uimenu(fed,'Label','复制','CallBack','editool(''copy'')');
    uimenu(fed,'Label','粘贴','CallBack','editool(''paste'')');
    uimenu(fed,'Label','零段','CallBack','modify(''zero'')','Separator','on');
    fm2=uimenu(fed,'Label','放大/衰减段');        
	uimenu(fm2,'Label','X2','CallBack','modify(''multi2'')');       
	uimenu(fm2,'Label','X0.5','CallBack','modify(''multi05'')');
     uimenu(fed,'Label','在光标处插入静音段','CallBack','iadsil');

    
    

fd=uimenu('Label','视图');
	uimenu(fd,'Label','时间波形','Callback','setdisp(''time'')');
       fd0= uimenu(fd,'Label','语谱图');
	uimenu(fd0,'Callback','setdisp(''spec'',''clr'')',...
	    'Label','颜色');
	uimenu(fd0,'Callback','setdisp(''spec'',''noclr'')',...
	    'Label','灰度');
	uimenu(fd0,'Callback','setdisp(''spec'',''4khz'')',...
	    'Label','0-4 kHz');
	uimenu(fd0,'Callback','setdisp(''spec'',''5khz'')',...
	    'Label','0-5 kHz');
	uimenu(fd0,'Callback','setdisp(''spec'',''full'')',...
	    'Label','满标度: 0-fs/2');
	fd01=uimenu(fd0,'Label','首选项');
	    preUp=uimenu(fd01,'Label','预加重','Checked','on',...
		   'Callback','prefer(''preemp'')');
	    fd02=uimenu(fd01,'Label','窗长');
		defUp=uimenu(fd02,'Label','默认','Checked','on',...
		   'Callback','prefer(''win_default'')');
		w64Up=uimenu(fd02,'Label','64 pts','Checked','off',...
		   'Callback','prefer(''win_64'')');
		w128Up=uimenu(fd02,'Label','128 pts','Checked','off',...
		   'Callback','prefer(''win_128'')');
		w256Up=uimenu(fd02,'Label','256 pts','Checked','off',...
		   'Callback','prefer(''win_256'')');
		w512Up=uimenu(fd02,'Label','512 pts','Checked','off',...
		   'Callback','prefer(''win_512'')');

	   fd03=uimenu(fd01,'Label','更新帧大小');
		uimenu(fd03,'Label','默认','Callback','prefer(''upd_default'')');
		uimenu(fd03,'Label','8 pts','Callback','prefer(''upd_8'')');
		uimenu(fd03,'Label','16 pts','Callback','prefer(''upd_16'')');
		uimenu(fd03,'Label','32 pts','Callback','prefer(''upd_32'')');
		uimenu(fd03,'Label','64 pts','Callback','prefer(''upd_64'')');
	
	 fd04=uimenu(fd01,'Label','共振峰增强');
		uimenu(fd04,'Label','默认','Callback','prefer(''enh_default'')');
		uimenu(fd04,'Label','0.3','Callback','prefer(''enh_3'')');
		uimenu(fd04,'Label','0.4','Callback','prefer(''enh_4'')');
		uimenu(fd04,'Label','0.5','Callback','prefer(''enh_5'')');
		uimenu(fd04,'Label','0.6','Callback','prefer(''enh_6'')');

	
	uimenu(fd,'Label','单窗口','Callback','setdisp(''single'')');
   
   
	uimenu(fd,'Label','能量图','Callback','engy');
	fdf0=uimenu(fd,'Label','F0 绘制');
	     uimenu(fdf0,'Label','自相关分析','Callback','estf0(''autocor'')');
	     uimenu(fdf0,'Label','倒谱分析','Callback','estf0(''cepstrum'')');
		uimenu(fd,'Label','共振峰轨迹','Callback','ftrack(''plot'')');
	uimenu(fd,'Label','功率谱密度','Callback','estpsd');
	fd2=uimenu(fd,'Label','首选项');
	    crsUp=uimenu(fd2,'Label','  显示光标线','Checked','on',...
		   'Callback','prefer(''crs'')');
	    

	
		
fv1=uimenu('Label','记录','CallBack','getrec');
fm1=uimenu('Label','工具');
    
                        
    uimenu(fm1,'Label','添加高斯噪声..','CallBack','isnr(''gaussian'')');
    uimenu(fm1,'Label','从文件添加噪声..','CallBack','isnr(''spec'')');
    fm3=uimenu(fm1,'Label','转换为 SCN 噪声','Callback','modify(''scn'')'); 
    uimenu(fm1,'Label','过滤器','Callback','filtool','Separator','on');
    uimenu(fm1,'Label','正弦波发生器','Callback','sintool');
    uimenu(fm1,'Label','标签工具','Callback','labtool'); 
    uimenu(fm1,'Label','比较工具','Callback','distool');
    uimenu(fm1,'Label','音量控制','Callback','voltool');

uimenu('Label','帮助','Callback','helpf(''colea'')');
%至少到这里都是在绘制控件
%----------- 初始化光标线句柄 ------------

np=3; Ylim=get(gca,'YLim');
hl=line('Xdata',[np np],'Ydata',Ylim,'Linestyle','-',...
	   'color',[0 0 0],'Erasemode','xor');

hr=line('Xdata',[np np],'Ydata',Ylim,'Linestyle','--',...
	   'color',[0 0 0],'Erasemode','xor');
doit=0;




