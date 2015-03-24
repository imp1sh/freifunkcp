local e=require"io"local e=require"os"local e=require"luci.ltn12"local e=require"nixio.fs"local n=require"nixio.util"local r=type
module"luci.fs"access=e.access
function glob(...)local e,r,i=e.glob(...)if e then
return n.consume(e)else
return nil,r,i
end
end
function isfile(n)return e.stat(n,"type")=="reg"end
function isdirectory(n)return e.stat(n,"type")=="dir"end
readfile=e.readfile
writefile=e.writefile
copy=e.datacopy
rename=e.move
function mtime(n)return e.stat(n,"mtime")end
function utime(i,r,n)return e.utimes(i,n,r)end
basename=e.basename
dirname=e.dirname
function dir(...)local e,i,r=e.dir(...)if e then
local e=n.consume(e)e[#e+1]="."e[#e+1]=".."return e
else
return nil,i,r
end
end
function mkdir(n,r)return r and e.mkdirr(n)or e.mkdir(n)end
rmdir=e.rmdir
local i={reg="regular",dir="directory",lnk="link",chr="character device",blk="block device",fifo="fifo",sock="socket"}function stat(r,n)local e,t,r=e.stat(r)if e then
e.mode=e.modestr
e.type=i[e.type]or"?"end
return n and e and e[n]or e,t,r
end
chmod=e.chmod
function link(r,n,i)return i and e.symlink(r,n)or e.link(r,n)end
unlink=e.unlink
readlink=e.readlink
