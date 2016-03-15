list={143 144 145 146};
for i=1:length(list)
    elm =  cell2mat(list(i));
    filename = sprintf('flownets-pred-0000%i.flo', elm);
    disp(filename);
    img =readFlowFile(filename);
    imwrite(img, sprintf('dubbelband%i.jpg', elm));
end