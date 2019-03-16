function [] = plot_kwave_slice(handles)
   
   h = imagesc(handles.axes1,handles.data(:,:,handles.t_index));
   p_focus = [249,133];
   %axis square tight
   if handles.flip_profile_dimension.Value
       profile = handles.data(:,p_focus(2),handles.t_index);
   else
       profile = handles.data(p_focus(1),:,handles.t_index);
   end
   plot(handles.axes2,profile); %hold on;
   ylim([-15,15]);
   %axis square tight
   %plot(handles.axes2,[1, size(handles.data,1)], [p_focus(1), p_focus(1)],'w--','linewidth',2);