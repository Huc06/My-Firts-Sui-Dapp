# Memory NFT Collection on Sui

Đây là một module viết bằng ngôn ngữ Move trên blockchain Sui, cho phép người dùng mint các NFT mang tính kỷ niệm (Memory NFT) một cách ngẫu nhiên từ các mẫu dữ liệu có sẵn (template).

## Tính năng chính

- Thêm mẫu NFT (Memory Template) với thông tin như tên, mô tả, ảnh và độ hiếm.
- Mint NFT một cách ngẫu nhiên từ các mẫu đã lưu.
- Quản lý template bằng `Table<u64, MemoryTemplate>`.
- Phát sự kiện khi NFT được tạo (`MemoryNFTCreated`).
- Mỗi NFT là một object duy nhất, sở hữu bởi người tạo.

## Cấu trúc chính

| Struct | Mô tả |
|--------|-------|
| `MemoryNFT` | NFT chứa các trường: `name`, `description`, `image_url`, `rarity` |
| `MemoryTemplate` | Mẫu dữ liệu để tạo NFT |
| `MemoryTemplateStore` | Object lưu trữ danh sách các template |
| `MemoryNFTCreated` | Event phát ra khi NFT được tạo thành công |

## Sử dụng Sui CLI

### 1. Build và publish module

```bash
sui move build
```

```bash
sui client publish --gas-budget 100000000
```

Sau khi publish, bạn sẽ thấy kết quả như sau:

```
Published Objects:
 PackageID: 0xc4ed76a97294a86e62d13f0900d71ec1354b8200657e77bd8d98413f31c1020c

Created Objects:
 ObjectID: 0xe29dc1f4251c9cf274376efdfd37a2544b0ef1a34f7db35191f5468bcad004a3
 ObjectType: 0xc4ed76a9...::my_nft_collection::MemoryTemplateStore
 Owner: Shared(...)
```

### 2. Gọi hàm thêm template

```bash
sui client call \
  --package 0xc4ed76a97294a86e62d13f0900d71ec1354b8200657e77bd8d98413f31c1020c \
  --module my_nft_collection \
  --function add_memory_template \
  --args 0xe29dc1f4251c9cf274376efdfd37a2544b0ef1a34f7db35191f5468bcad004a3 \
         "My NFT" "This is a test NFT" "https://example.com/image.png" 100 \
  --gas-budget 100000000
```

### 3. Gọi hàm mint NFT ngẫu nhiên

```bash
sui client call \
  --package 0xc4ed76a97294a86e62d13f0900d71ec1354b8200657e77bd8d98413f31c1020c \
  --module my_nft_collection \
  --function mint_random_memory_nft \
  --args 0xe29dc1f4251c9cf274376efdfd37a2544b0ef1a34f7db35191f5468bcad004a3 \
  --gas-budget 100000000
```

## Kiểm tra kết quả trên Suiscan

1. Truy cập [https://suiscan.xyz](https://suiscan.xyz)
2. Dán `objectId` hoặc `Transaction Digest` để kiểm tra thông tin object, giao dịch và sự kiện.

## Ví dụ dữ liệu NFT

```json
{
  "name": "Blockchain Memory",
  "description": "A special moment stored on Sui",
  "image_url": "https://example.com/image.png",
  "rarity": 150
}
```

## Yêu cầu

- Cài đặt Sui CLI: https://docs.sui.io
- Ví Sui (Sui Wallet hoặc keypair CLI)
- Kết nối đúng Devnet / Testnet / Mainnet
- Sử dụng `image_url` hợp lệ (HTTPS)

## Tác giả

Hà Phúc Nguyễn - HÚC  
GitHub: https://github.com/Huc06

## License

MIT License – xem chi tiết trong file LICENSE

## Nguyên tắc mã nguồn mở

Dự án này được công khai theo giấy phép MIT và khuyến khích cộng đồng đóng góp. Khi bạn muốn:

- Fork lại để phát triển riêng: được phép.
- Sửa đổi, tái sử dụng mã nguồn: hãy ghi rõ nguồn (credit).
- Đóng góp: tạo Pull Request (PR) rõ ràng và có kiểm thử.
- Phát hành thương mại: được phép, miễn là tuân thủ điều khoản MIT.

Nếu bạn muốn hợp tác hoặc có ý tưởng mở rộng, hãy liên hệ qua GitHub hoặc email cá nhân.
