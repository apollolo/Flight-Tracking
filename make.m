function [store, varargout] = make(y)
for n = 1:24
    len = find(y==(n-1));
    vec(n) = length(len);
    store{n} = len;
end
x = 0:23;
%bar(x,vec)
if nargout == 2
    varargout{1} = vec;
end
end