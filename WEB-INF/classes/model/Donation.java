package model;

/**
 * Donation Model Class
 * Represents a food donation in the Online Food Donation System
 */
public class Donation {
    private int id;
    private int donorId;
    private String foodName;
    private String foodCategory;
    private double quantity;
    private String unit;
    private String description;
    private String expiryDate;
    private String pickupAddress;
    private String contactNumber;
    private String donorName;
    private String status;
    private String createdAt;

    // Default constructor
    public Donation() {}

    // Constructor for saving new donation
    public Donation(int donorId, String foodName, String foodCategory, double quantity, 
                    String unit, String description, String expiryDate, String pickupAddress, 
                    String contactNumber, String donorName) {
        this.donorId = donorId;
        this.foodName = foodName;
        this.foodCategory = foodCategory;
        this.quantity = quantity;
        this.unit = unit;
        this.description = description;
        this.expiryDate = expiryDate;
        this.pickupAddress = pickupAddress;
        this.contactNumber = contactNumber;
        this.donorName = donorName;
    }

    // Full constructor
    public Donation(int id, int donorId, String foodName, String foodCategory, double quantity, 
                    String unit, String description, String expiryDate, String pickupAddress, 
                    String contactNumber, String donorName, String status, String createdAt) {
        this.id = id;
        this.donorId = donorId;
        this.foodName = foodName;
        this.foodCategory = foodCategory;
        this.quantity = quantity;
        this.unit = unit;
        this.description = description;
        this.expiryDate = expiryDate;
        this.pickupAddress = pickupAddress;
        this.contactNumber = contactNumber;
        this.donorName = donorName;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }
    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }
    public String getFoodCategory() { return foodCategory; }
    public void setFoodCategory(String foodCategory) { this.foodCategory = foodCategory; }
    public double getQuantity() { return quantity; }
    public void setQuantity(double quantity) { this.quantity = quantity; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getExpiryDate() { return expiryDate; }
    public void setExpiryDate(String expiryDate) { this.expiryDate = expiryDate; }
    public String getPickupAddress() { return pickupAddress; }
    public void setPickupAddress(String pickupAddress) { this.pickupAddress = pickupAddress; }
    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }
    public String getDonorName() { return donorName; }
    public void setDonorName(String donorName) { this.donorName = donorName; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
