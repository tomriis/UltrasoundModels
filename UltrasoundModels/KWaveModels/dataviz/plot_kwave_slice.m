function [] = plot_kwave_slice(handles)
   
   h = imagesc(handles.axes1,handles.data(:,:,handles.t_index));
   p_focus = [374,296];
   %axis square tight
  
   profile = handles.data(p_focus(1),:,handles.t_index);
   plot(handles.axes2,profile); %hold on;
   ylim([-10,10]);
   %axis square tight
   %plot(handles.axes2,[1, size(handles.data,1)], [p_focus(1), p_focus(1)],'w--','linewidth',2);