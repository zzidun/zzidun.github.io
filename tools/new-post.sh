mkdir posts/$2
touch posts/$2/$1.md -r
current_date=`date +'%Y-%m-%d'`

echo "---" >> posts/$1.md
echo "title: $1" >> posts/$1.md
echo "author: zzidun" >> posts/$1.md
echo "date: $current_date" >> posts/$1.md
echo "tags: $2" >> posts/$1.md
echo "---" >> posts/$1.md
