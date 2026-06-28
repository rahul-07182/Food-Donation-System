package model;

/**
 * FoodRequest Model Class
 * Represents an NGO food request in the Online Food Donation System (Phase 6)
 */
public class FoodRequest {

    private int id;
    private int ngoId;
    private String foodNeeded;
    private double quantity;
    private String address;
    private String contactNumber;
    private String ngoName;
    private String requestStatus; // pending, accepted, completed
    private String createdAt;

    public FoodRequest() {
    }

    public FoodRequest(int ngoId, String foodNeeded, double quantity, String address,
                       String contactNumber, String ngoName) {
        this.ngoId = ngoId;
        this.foodNeeded = foodNeeded;
        this.quantity = quantity;
        this.address = address;
        this.contactNumber = contactNumber;
        this.ngoName = ngoName;
        this.requestStatus = "pending";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNgoId() {
        return ngoId;
    }

    public void setNgoId(int ngoId) {
        this.ngoId = ngoId;
    }

    public String getFoodNeeded() {
        return foodNeeded;
    }

    public void setFoodNeeded(String foodNeeded) {
        this.foodNeeded = foodNeeded;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getNgoName() {
        return ngoName;
    }

    public void setNgoName(String ngoName) {
        this.ngoName = ngoName;
    }

    public String getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(String requestStatus) {
        this.requestStatus = requestStatus;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Display-friendly status label
     */
    public String getStatusDisplay() {
        if (requestStatus == null) {
            return "Pending";
        }
        switch (requestStatus.toLowerCase()) {
            case "accepted":
                return "Accepted";
            case "completed":
                return "Completed";
            default:
                return "Pending";
        }
    }
}
