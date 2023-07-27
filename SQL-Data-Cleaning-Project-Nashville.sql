--Cleaning Data 

--1.Property Address
Select * from nashville
--where PropertyAddress is null
order by ParcelID

--Self Join
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville a join Nashville b
on a.ParcelID = b.ParcelID and a.UniqueID<> b.UniqueID
where a.PropertyAddress is null

--Removing Null values in Property Address

Update a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville a join Nashville b
on a.ParcelID = b.ParcelID and a.UniqueID<> b.UniqueID
where a.PropertyAddress is null

--Breaking the Address into individual columns(Address,City,State) 

select propertyaddress from Nashville;

select 
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as Addr,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1 ,len(propertyaddress)) as addr from Nashville;

Alter table nashville
add PropertysplitAddress nvarchar(255);

Update nashville
set PropertysplitAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1);

Alter table nashville
add PropertysplitCity nvarchar(255);

Update nashville
set PropertysplitCity = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1 ,len(propertyaddress));

select OwnerAddress from Nashville;

Select
PARSENAME(Replace(ownerAddress,',','.'),3),
PARSENAME(Replace(ownerAddress,',','.'),2),
PARSENAME(Replace(ownerAddress,',','.'),1)
from nashville

Alter table nashville
add OwnersplitAddress nvarchar(255);

Update nashville
set OwnersplitAddress = PARSENAME(Replace(ownerAddress,',','.'),1);

Alter table nashville
add OwnersplitCity nvarchar(255);

Update nashville
set OwnersplitCity = PARSENAME(Replace(ownerAddress,',','.'),2);

Alter table nashville
add OwnersplitState nvarchar(255);

Update nashville
set OwnersplitState = PARSENAME(Replace(ownerAddress,',','.'),3);

--Change Y and N into 'Yes' and 'No' in sold as Vaccant field
Select * from Nashville;


alter table nashville
alter column soldasvacant nvarchar(25);

select soldasvacant 
,CASE
when SoldAsVacant = '0' then 'No'
when SoldAsVacant= '1' then 'Yes'
else SoldAsVacant
end
from Nashville

Update Nashville
set SoldAsVacant = CASE
when SoldAsVacant = '0' then 'No'
when SoldAsVacant= '1' then 'Yes'
else SoldAsVacant
end
from Nashville

select distinct(soldasvacant),count(soldasvacant) from Nashville
group by soldasvacant
order by 2;

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From Nashville
)

Delete
From RowNumCTE
Where row_num > 1

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From Nashville
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--Delete Unused Columns

Select *
From Nashville


ALTER TABLE Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

