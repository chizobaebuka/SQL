--Selecting all columns before cleaning the data
Select *
From [Nashville Housing]..NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------------
--Changing the Saledate format
Select SaleDateConverted, CONVERT(Date, SaleDate)
From [Nashville Housing]..NashvilleHousing

--Updating the table by Setting the SaleDate format
UPDATE NashvilleHousing
Set SaleDate = CONVERT(Date, SaleDate)

--Altering the table to add the SaleDateConverted and converting it to Date format
ALTER Table NashvilleHousing
Add SaleDateConverted Date;

--Updating the table by Setting the SaleDateConverted format
UPDATE NashvilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)
-------------------------------------------------------------------------------------------------------------------------------------

-- Populating the Property Address Data
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Nashville Housing]..NashvilleHousing a
	JOIN [Nashville Housing]..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] < > b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Nashville Housing]..NashvilleHousing a
	JOIN [Nashville Housing]..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] < > b.[UniqueID ]
where a.PropertyAddress is null
-------------------------------------------------------------------------------------------------------------------------------------
--Breaking the PropertyAddress into the Individual Columns (Address, City, State)

--Selecting the PropertyAddress and ordering it by Parcel ID
Select PropertyAddress
From [Nashville Housing]..NashvilleHousing
--where PropertyAddress is null
Order by ParcelID

--This breaks the Property address into Address and City, done by removing the demiliter (comma ,)
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City 
From [Nashville Housing]..NashvilleHousing

--After breaking the address, the table has to be altered and updated for the address so it could be effected in the table later on
ALTER Table [Nashville Housing]..NashvilleHousing
Add PropertySplitAddress nvarchar(255);

--Updating the table by Setting the PropertySplitAddress format
UPDATE [Nashville Housing]..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


--After breaking the address, the table has to be altered and updated for the City so it could be effected in the table later on
ALTER Table [Nashville Housing]..NashvilleHousing
Add PropertySplitCity nvarchar(255);

--Updating the table by Setting the PropertySplitCity format
UPDATE [Nashville Housing]..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

--Selecting the whole table to show the newly effected columns on the table 
Select *
From [Nashville Housing]..NashvilleHousing

--Breaking the Owner Address into the Individual Columns (Address, City, State)
Select OwnerAddress
From [Nashville Housing]..NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',','.') ,3) as Address
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,2) as City
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,1) as State
From [Nashville Housing]..NashvilleHousing

--Altering the table to Add the OwnerSplitAddress
ALTER Table [Nashville Housing]..NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

--Updating the table to Set the new OwnerSplitAddress
UPDATE [Nashville Housing]..NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)

--Altering the table to Add the OwnerSplitCity
ALTER Table [Nashville Housing]..NashvilleHousing
Add OwnerSplitCity nvarchar(255);

--Updating the table to Set the new OwnerSplitCity
UPDATE [Nashville Housing]..NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

--Altering the table to Add the OwnerSplitState
ALTER Table [Nashville Housing]..NashvilleHousing
Add OwnerSplitState nvarchar(255);

--Updating the table to Set the new OwnerSplitState
UPDATE [Nashville Housing]..NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)

--Selecting all after the columns have all been effected in the table 
Select *
FROM [Nashville Housing]..NashvilleHousing
------------------------------------------------------------------------------------------------------------------------------------

--Changing Y to Yes and N to NO in the SoldAsVacant Field/Column
Select distinct (SoldAsVacant), Count(SoldAsVacant)
From [Nashville Housing]..NashvilleHousing
Group by SoldAsVacant
Order by 2


--To change the words from Y to YES and N to NO in the SoldAsVacant FIeld/Column, make use of the CASE STATEMENT
Select (SoldAsVacant)
, CASE When SoldAsVacant = 'Y' THEN 'YES'
	 When SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
From [Nashville Housing]..NashvilleHousing

--Updating the Table to effect the new change of the Case statement into the table thereby changing the Y to Yes and N to NO
UPDATE [Nashville Housing]..NashvilleHousing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' THEN 'YES'
	 When SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
-----------------------------------------------------------------------------------------------------------------------------------
--REMOVING DUPLICATES
WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
FROM [Nashville Housing]..NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
where row_num > 1
--Order by PropertyAddress
-------------------------------------------------------------------------------------------------------------------------------------

--DELETING UNUSED COLUMNS 

--Selecting all columns after the columns needed to be removed have been altered and removed
SELECT *
FROM [Nashville Housing]..NashvilleHousing

--Altering the table to remove the OwnerAddress, TaxDistrict, and PropertyAddress
ALTER TABLE [Nashville Housing]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

--Altering the table to remove the SaleDate
ALTER TABLE [Nashville Housing]..NashvilleHousing
DROP COLUMN SaleDate
-------------------------------------------------------------------------------------------------------------------------------------
