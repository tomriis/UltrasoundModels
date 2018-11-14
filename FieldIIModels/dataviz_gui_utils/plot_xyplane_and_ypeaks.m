function [] = plot_xyplane_and_ypeaks(axes1,axes2,txfielddb)
        x = (-60 : 0.5 : 60)*1e-3;
        y = x;
        imagesc(axes1, x*1e3, y*1e3, txfielddb);
        axis equal tight;
        xlabel(axes1,'x (mm)');
        ylabel(axes1,'y (mm)');
        ch = colorbar; ylabel(ch, 'dB'); 
        set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
        XL = 60; 
        plot(axes2, x*1e3, txfielddb(round(length(txfielddb) / 2), :)); 
        xlim(axes2,[-XL XL]); hold on; plot(axes2, [-XL, XL], [-6 -6], 'k--', 'linewidth', 2);
        xlabel(axes2,'x (mm)');
end