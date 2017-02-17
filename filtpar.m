function filtpar(type,param1)


% Copyright (c) 1995 Philipos C. Loizou
%
global filtFig lpfN lpfF Srate fcLPF nuLPF hpfN hpfF  fcHPF nuHPF
global fc1BPF fc2BPF nuBPF bpfF1 bpfF2 bpfN

if strcmp(type,'LPF')

	if strcmp(param1,'freq')
	  x=get(lpfF,'String');
	  f=str2num(x);
	  if f >0 & 2*f < Srate
	    fcLPF=f;
	  else
	    errordlg('无效的频率输入..','过滤器工具错误','on');    
	    return;
	  end
	  
	elseif strcmp(param1,'coeff')
	   x=get(lpfN,'String');
	  f=str2num(x);
	  if f >0 & f< 30
	    nuLPF=f;
	  else
	    errordlg('无效数的多项式系数输入..','过滤器工具错误','on');    
	    return;
	  end
	end

    figure(filtFig);

elseif strcmp(type,'HPF') %----------- Get HPF parameters --------------------
	if strcmp(param1,'freq')
	  x=get(hpfF,'String');
	  f=str2num(x);
	  if f >0 & 2*f < Srate
	    fcHPF=f;
	  else
	    errordlg('无效的频率输入..','过滤器工具错误','on');    
	    return;
	  end
	  
	elseif strcmp(param1,'coeff')
	   x=get(hpfN,'String');
	  f=str2num(x);
	  if f >0 & f< 30
	    nuHPF=f;
	  else
	    errordlg('无效数的多项式系数输入..','过滤器工具错误','on');    
	    return;
	  end
	end

 	figure(filtFig);
else			%----------- Get BPF parameters--------------
	if strcmp(param1,'freq1') %-low freq
	  x=get(bpfF1,'String');
	  f=str2num(x);
	  if f >0 & 2*f < Srate
	    fc1BPF=f;
	  else
	    errordlg('无效的频率输入..','过滤器工具错误','on');    
	    return;
	  end
	elseif strcmp(param1,'freq2') %--high freq
	 x=get(bpfF2,'String');
	  f=str2num(x);
	  if f >0 & 2*f < Srate
	    fc2BPF=f;
	  else
	    errordlg('无效的频率输入..','过滤器工具错误','on');    
	    return;
	  end  
	elseif strcmp(param1,'coeff')
	   x=get(bpfN,'String');
	  f=str2num(x);
	  if f >0 & f< 30
	    nuBPF=f;
	  else
	    errordlg('无效数的多项式系数输入..','过滤器工具错误','on');    
	    return;
	  end
	end
	%----- Check range in pass band ---------------
 	if fc1BPF>fc2BPF
	  errordlg('低截止频率大于高截止频率..','过滤器工具错误','on');
	else
 	  figure(filtFig);
	end
end
