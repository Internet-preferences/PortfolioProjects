/*

Cleaning Data with SQL Queries

*/

-- Select *
-- From PortfolioProject..[Nashville Housing Data]


-- -- Standardize the Sale Date
-- SELECT SaleDate, Convert(Date, SaleDate)
-- From PortfolioProject..[Nashville Housing Data]

-- Update [Nashville Housing Data]
-- Set SaleDate = Convert(Date,SaleDate)


-- -- Populate Property Adress
-- Select PropertyAddress
-- From PortfolioProject..[Nashville Housing Data]
-- Where PropertyAddress is NULL

SELECT *
From PortfolioProject..NashvilleHousingData


-- Populate Property Address
Select *
From PortfolioProject..NashvilleHousingData
-- Where PropertyAddress is NULL
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousingData a
Join PortfolioProject..NashvilleHousingData b
on a.ParcelID = b.ParcelID
AND a.[UniqueID]<> b.[UniqueID]
Where a.PropertyAddress is null

UPDATE a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousingData a
Join PortfolioProject..NashvilleHousingData b
on a.ParcelID = b.ParcelID
AND a.[UniqueID]<> b.[UniqueID]
Where a.PropertyAddress is null


-- Breaking Out Adress into INtividual Columns (Adress, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousingData


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From PortfolioProject..NashvilleHousingData

Alter Table NashvilleHousingData
add PropertySplitAddress nvarchar(255);

Update NashvilleHousingData
Set PropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Alter Table NashvilleHousingData
Add PropertySplitCity nvarchar(255);

Update NashvilleHousingData
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousingData

Select OwnerAddress
From PortfolioProject..NashvilleHousingData

SELECT
PARSENAME(Replace(OwnerAddress, ',', '.' ) , 1)
from PortfolioProject..NashvilleHousingData

Alter Table NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousingData

Set OwnerSplitAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))ALTER TABLE NashvilleHousingData
Add PropertySplitAddress nvarchar(255);

Alter Table NashvilleHousingData
Add OwnerSplitState nvarchar(255);

Update NashvilleHousingData
Set OwnerSplitState = SUBSTRING()(PropertyAddress, CHAR(',', PropertyAddress) + 1 , LEN(PropertyAddress))
