# Family Photo Sharing Quick Start

This guide will help you quickly set up Immich for sharing photos with your family.

## What You'll Get

- **Web Interface**: Browse and share photos at `https://photos.your-domain.com`
- **Mobile Apps**: iOS and Android apps for easy photo uploads and viewing
- **Face Recognition**: Automatically organize photos by family members
- **Album Sharing**: Create and share albums with family members
- **Secure Access**: TLS encryption for safe photo sharing

## Quick Setup (5 minutes)

### 1. Configure Your Setup

```bash
./install_immich.sh configure
```

You'll be asked for:
- **PostgreSQL details**: Host, database name, username, password
- **Domain name**: Like `photos.yourfamily.com` or `photos.your-domain.com`

### 2. Deploy Immich

```bash
./install_immich.sh deploy
```

### 3. Check Status

```bash
./install_immich.sh status
```

Wait for all pods to show "Running" status.

## First Time Setup

### 1. Create Admin Account
- Open your browser to `https://photos.your-domain.com`
- Create your first admin user account
- This will be the main account for managing family photos

### 2. Download Mobile Apps
- **iOS**: Search "Immich" in App Store
- **Android**: Search "Immich" in Google Play Store
- Configure apps with your server URL: `https://photos.your-domain.com`

### 3. Upload Your First Photos
- Use the web interface to upload some family photos
- Or use the mobile app to upload photos from your phone
- Immich will automatically create thumbnails and organize photos

### 4. Set Up Family Sharing
- Create albums for different family events or categories
- Invite family members by email
- They'll receive an email to create their own accounts

## Family Features

### Photo Organization
- **Automatic Face Recognition**: Immich learns family faces and groups photos
- **Smart Albums**: Automatically organize photos by date, location, or people
- **Search**: Find photos by person, date, or location

### Sharing Options
- **Private Albums**: Only you can see
- **Shared Albums**: Invite family members to view and contribute
- **Public Links**: Create temporary links to share specific photos

### Mobile Experience
- **Automatic Upload**: Set up automatic photo backup from phones
- **Offline Viewing**: Download albums for offline access
- **Easy Sharing**: Share photos directly from the mobile app

## Storage & Performance

Your setup includes:
- **300GB Storage**: Plenty for family photo collections
- **Fast Loading**: Optimized for smooth photo viewing
- **Reliable**: Multiple replicas ensure availability

## Security

- **TLS Encryption**: All data is encrypted in transit
- **User Accounts**: Each family member has their own secure account
- **Access Control**: You control who can see and upload photos

## Troubleshooting

### Common Issues

**Can't access the website?**
- Check if pods are running: `kubectl get pods -n immich`
- Verify your domain DNS is pointing to your server
- Check if TLS certificate is valid

**Photos not uploading?**
- Check storage capacity: `kubectl get pvc -n immich`
- Verify database connection in logs: `kubectl logs -n immich deployment/immich-server`

**Slow photo loading?**
- Check resource usage: `kubectl top pods -n immich`
- Consider increasing storage or resources if needed

### Getting Help

- **Immich Documentation**: https://immich.app/docs
- **Community Support**: https://github.com/immich-app/immich/discussions
- **Mobile App Help**: Check the app's built-in help section

## Tips for Family Use

1. **Start Small**: Upload a few photos first to test everything works
2. **Create Albums**: Organize photos into albums by event or year
3. **Invite Family**: Add family members one by one to avoid confusion
4. **Set Expectations**: Let family know this is for sharing, not backup
5. **Regular Backups**: Keep copies of important photos elsewhere too

## Maintenance

### Regular Tasks
- **Monitor Storage**: Check storage usage monthly
- **Update Software**: Immich updates automatically through GitOps
- **Backup Database**: Ensure your PostgreSQL database is backed up

### Performance Tips
- **SSD Storage**: Use SSD storage for faster photo loading
- **Good Internet**: Ensure good upload/download speeds
- **Regular Cleanup**: Remove duplicate or unwanted photos

## Enjoy Your Family Photos!

Once set up, you'll have a beautiful, secure way to share and organize your family's precious memories. The face recognition will help you quickly find photos of specific family members, and the sharing features make it easy to include everyone in your photo collection. 