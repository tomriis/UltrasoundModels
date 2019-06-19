function visualize_field(txfielddb, x,y)
    figure;
    imagesc(x*1e3, y*1e3, txfielddb);
    axis equal tight;
    xlabel('x (mm)');
    ylabel('y (mm)');
    ch = colorbar; ylabel(ch, 'dB'); 
    caxis([-55,0]);
    set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
%     figure;
%     XL = min(x)*1e3;
%     XH = max(x)*1e3;
%     profile = txfielddb(:, length(x)/2);
%     plot(x*1e3, profile); 
%     xlim([XL XH]); hold on; plot([XL, XH], [-6 -6], 'k--', 'linewidth', 2);
%     xlabel('y (mm)');
%     
%     figure;
%     XL = min(x)*1e3;
%     XH = max(x)*1e3;
%     profile = txfielddb(length(y)/2,:);
%     plot(y*1e3, profile); 
%     xlim([XL XH]); hold on; plot([XL, XH], [-6 -6], 'k--', 'linewidth', 2);
%     xlabel('x (mm)');
end